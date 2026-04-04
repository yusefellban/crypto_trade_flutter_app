import 'package:dio/dio.dart';
import '../../models/coin_model.dart';
import '../../models/trending_coin_model.dart';
import '../../models/coin_detail_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  final Dio _dio;
  final String _baseUrl = "https://api.coingecko.com/api/v3/";

  ApiService(this._dio);

  Future<List<CoinModel>> getTopCoins({
    String vsCurrency = "usd",
    String order = "market_cap_desc",
    int perPage = 20,
    int page = 1,
    bool sparkline = true,
  }) async {
    try {
      final response = await _dio.get(
        "${_baseUrl}coins/markets",
        queryParameters: {
          "vs_currency": vsCurrency,
          "order": order,
          "per_page": perPage,
          "page": page,
          "sparkline": sparkline,
        },
      );
      return (response.data as List)
          .map((i) => CoinModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ApiException("An unexpected error occurred. Please try again.");
    }
  }

  Future<TrendingResponse> getTrendingCoins() async {
    try {
      final response = await _dio.get("${_baseUrl}search/trending");
      return TrendingResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ApiException("An unexpected error occurred. Please try again.");
    }
  }

  Future<CoinDetailModel> getCoinDetail(String id) async {
    try {
      final response = await _dio.get("${_baseUrl}coins/$id");
      return CoinDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ApiException("An unexpected error occurred. Please try again.");
    }
  }

  ApiException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException("Connection timed out. Please check your internet.");
    }

    if (error.type == DioExceptionType.connectionError) {
      return ApiException("No internet connection.");
    }

    if (error.response?.statusCode == 429) {
      return ApiException("Too many requests (Rate Limit). Please wait a moment.", statusCode: 429);
    }

    if (error.response?.statusCode != null && error.response!.statusCode! >= 500) {
      return ApiException("Server error. Please try again later.", statusCode: error.response?.statusCode);
    }

    return ApiException("Something went wrong. Please try again.");
  }
}

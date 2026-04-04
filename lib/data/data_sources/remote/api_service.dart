import 'package:dio/dio.dart';
import '../../models/coin_model.dart';
import '../../models/trending_coin_model.dart';
import '../../models/coin_detail_model.dart';

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
  }

  Future<TrendingResponse> getTrendingCoins() async {
    final response = await _dio.get("${_baseUrl}search/trending");
    return TrendingResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CoinDetailModel> getCoinDetail(String id) async {
    final response = await _dio.get("${_baseUrl}coins/$id");
    return CoinDetailModel.fromJson(response.data as Map<String, dynamic>);
  }
}

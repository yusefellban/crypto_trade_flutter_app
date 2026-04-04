import '../data_sources/remote/api_service.dart';
import '../models/coin_model.dart';
import '../models/trending_coin_model.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<CoinModel>> getTopCoins() async {
    return await _apiService.getTopCoins();
  }

  Future<TrendingResponse> getTrendingCoins() async {
    return await _apiService.getTrendingCoins();
  }
}

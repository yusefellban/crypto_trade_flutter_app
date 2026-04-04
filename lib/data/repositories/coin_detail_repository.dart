import '../data_sources/remote/api_service.dart';
import '../models/coin_detail_model.dart';

class CoinDetailRepository {
  final ApiService _apiService;

  CoinDetailRepository(this._apiService);

  Future<CoinDetailModel> getCoinDetail(String id) async {
    return await _apiService.getCoinDetail(id);
  }
}

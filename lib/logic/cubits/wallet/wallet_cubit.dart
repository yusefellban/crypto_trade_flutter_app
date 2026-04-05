import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/database_service.dart';
import '../../../data/models/coin_model.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final DatabaseService _databaseService;

  WalletCubit(this._databaseService) : super(WalletInitial());

  Future<void> loadWallet() async {
    emit(WalletLoading());
    try {
      final coinsData = await _databaseService.getWalletCoins();
      final coins = coinsData.map((data) => CoinModel(
        id: data['id'],
        symbol: data['symbol'],
        name: data['name'],
        image: data['image'],
        currentPrice: data['current_price'],
        priceChangePercentage24h: data['price_change_percentage_24h'],
      )).toList();
      emit(WalletLoaded(coins));
    } catch (e) {
      emit(const WalletError('Failed to load wallet data.'));
    }
  }

  Future<void> toggleWallet(CoinModel coin) async {
    try {
      final isInWallet = await _databaseService.isCoinInWallet(coin.id);
      if (isInWallet) {
        await _databaseService.removeCoinFromWallet(coin.id);
      } else {
        await _databaseService.addCoinToWallet(coin);
      }
      // Reload the wallet after toggle
      await loadWallet();
    } catch (e) {
      emit(const WalletError('Could not update wallet.'));
    }
  }

  Future<bool> checkInWallet(String id) async {
    return await _databaseService.isCoinInWallet(id);
  }
}

import '../../../data/models/coin_detail_model.dart';

abstract class CoinDetailState {}

class CoinDetailInitial extends CoinDetailState {}

class CoinDetailLoading extends CoinDetailState {}

class CoinDetailLoaded extends CoinDetailState {
  final CoinDetailModel coinDetail;

  CoinDetailLoaded(this.coinDetail);
}

class CoinDetailError extends CoinDetailState {
  final String message;

  CoinDetailError(this.message);
}

import '../../data/models/coin_model.dart';
import '../../data/models/trending_coin_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CoinModel> topCoins;
  final List<TrendingCoinListItem> trendingCoins;

  HomeLoaded({required this.topCoins, required this.trendingCoins});
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

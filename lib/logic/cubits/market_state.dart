import 'package:equatable/equatable.dart';
import '../../data/models/coin_model.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<CoinModel> coins;

  const MarketLoaded({required this.coins});

  @override
  List<Object> get props => [coins];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object> get props => [message];
}

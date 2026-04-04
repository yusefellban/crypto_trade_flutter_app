import 'package:equatable/equatable.dart';
import '../../data/models/trending_coin_model.dart';

abstract class TradesState extends Equatable {
  const TradesState();

  @override
  List<Object?> get props => [];
}

class TradesInitial extends TradesState {}

class TradesLoading extends TradesState {}

class TradesLoaded extends TradesState {
  final TrendingResponse trendingResponse;

  const TradesLoaded({required this.trendingResponse});

  @override
  List<Object?> get props => [trendingResponse];
}

class TradesError extends TradesState {
  final String message;

  const TradesError(this.message);

  @override
  List<Object?> get props => [message];
}

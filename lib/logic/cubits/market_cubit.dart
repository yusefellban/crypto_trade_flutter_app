import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final HomeRepository _repository;

  MarketCubit(this._repository) : super(MarketInitial());

  Future<void> fetchMarketData() async {
    emit(MarketLoading());
    try {
      final coins = await _repository.getTopCoins();
      emit(MarketLoaded(coins: coins));
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }
}

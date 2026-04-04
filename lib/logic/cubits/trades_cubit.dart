import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'trades_state.dart';

class TradesCubit extends Cubit<TradesState> {
  final HomeRepository _repository;

  TradesCubit(this._repository) : super(TradesInitial());

  Future<void> fetchTrendingCoins() async {
    emit(TradesLoading());
    try {
      final trendingResponse = await _repository.getTrendingCoins();
      emit(TradesLoaded(trendingResponse: trendingResponse));
    } catch (e) {
      emit(TradesError(e.toString()));
    }
  }
}

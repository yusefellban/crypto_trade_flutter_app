import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/coin_detail_repository.dart';
import 'coin_detail_state.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  final CoinDetailRepository _repository;

  CoinDetailCubit(this._repository) : super(CoinDetailInitial());

  Future<void> fetchCoinDetail(String id) async {
    emit(CoinDetailLoading());
    try {
      final detail = await _repository.getCoinDetail(id);
      emit(CoinDetailLoaded(detail));
    } catch (e) {
      emit(CoinDetailError(e.toString()));
    }
  }
}

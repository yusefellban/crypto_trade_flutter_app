import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final topCoins = await _repository.getTopCoins();
      final trendingResponse = await _repository.getTrendingCoins();
      
      emit(HomeLoaded(
        topCoins: topCoins,
        trendingCoins: trendingResponse.coins ?? [],
      ));
    } catch (e) {
      emit(HomeError("Failed to fetch data: ${e.toString()}"));
    }
  }
}

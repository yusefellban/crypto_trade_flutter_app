import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/data_sources/remote/api_service.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/coin_detail_repository.dart';
import '../../logic/cubits/home_cubit.dart';
import '../../logic/cubits/market_cubit.dart';
import '../../logic/cubits/coin_detail/coin_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton(() => Dio());

  // Api Service
  sl.registerLazySingleton(() => ApiService(sl()));

  // Repository
  sl.registerLazySingleton(() => HomeRepository(sl()));
  sl.registerLazySingleton(() => CoinDetailRepository(sl()));

  // Cubit
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => MarketCubit(sl()));
  sl.registerFactory(() => CoinDetailCubit(sl()));
}

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_sources/remote/api_service.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/coin_detail_repository.dart';
import '../../logic/cubits/home_cubit.dart';
import '../../logic/cubits/market_cubit.dart';
import '../../logic/cubits/trades_cubit.dart';
import '../../logic/cubits/coin_detail/coin_detail_cubit.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../logic/cubits/wallet/wallet_cubit.dart';
import '../services/preference_service.dart';
import '../services/database_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Services
  sl.registerLazySingleton(() => PreferenceService(sl()));
  sl.registerLazySingleton(() => DatabaseService());

  // Api Service
  sl.registerLazySingleton(() => ApiService(sl()));

  // Repository
  sl.registerLazySingleton(() => HomeRepository(sl()));
  sl.registerLazySingleton(() => CoinDetailRepository(sl()));

  // Cubit
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => MarketCubit(sl()));
  sl.registerFactory(() => TradesCubit(sl()));
  sl.registerFactory(() => CoinDetailCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  sl.registerFactory(() => WalletCubit(sl()));
}

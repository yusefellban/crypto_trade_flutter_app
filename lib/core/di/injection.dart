import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/data_sources/remote/api_service.dart';
import '../../data/repositories/home_repository.dart';
import '../../logic/cubits/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton(() => Dio());

  // Api Service
  sl.registerLazySingleton(() => ApiService(sl()));

  // Repository
  sl.registerLazySingleton(() => HomeRepository(sl()));

  // Cubit
  sl.registerFactory(() => HomeCubit(sl()));
}

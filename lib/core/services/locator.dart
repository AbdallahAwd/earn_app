import 'package:earnlia/features/home/data/datasources/home_data_source.dart';
import 'package:earnlia/features/home/data/repositories/home_repo.dart';
import 'package:earnlia/features/home/domain/repositories/base_get_user_repo.dart';
import 'package:earnlia/features/login/data/datasources/login_reomte_data_source.dart';
import 'package:earnlia/features/login/data/repositories/login_repo.dart';
import 'package:earnlia/features/login/domain/repositories/base_login_repo.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static init() {
    //repository
    sl.registerLazySingleton<BaseLoginRepository>(() => LoginRepository(sl()));
    sl.registerLazySingleton<BaseHomeRepository>(() => HomeRepository(sl()));
    //renote db firebase
    sl.registerLazySingleton<BaseLoginRemoteDataSource>(
        () => LoginRemoteDataSource());
    sl.registerLazySingleton<BaseUserDataSource>(() => UserDataSource());
  }
}

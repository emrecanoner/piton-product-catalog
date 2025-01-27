// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/repositories/auth_repository.dart' as _i1041;
import '../../features/splash/providers/splash_provider.dart' as _i319;
import 'modules/storage_module.dart' as _i148;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i319.SplashNotifier>(() => _i319.SplashNotifier());
    gh.factory<_i1041.IAuthRepository>(() => _i1041.AuthRepository());
    return this;
  }
}

class _$StorageModule extends _i148.StorageModule {}

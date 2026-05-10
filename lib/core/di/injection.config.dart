// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart' as _i331;
import '../../features/tasks/data/datasources/tasks_local_datasource.dart'
    as _i453;
import '../../features/tasks/data/datasources/tasks_remote_datasource.dart'
    as _i547;
import '../../features/tasks/data/repositories/tasks_repository_impl.dart'
    as _i220;
import '../../features/tasks/data/services/sql_lite_service.dart' as _i141;
import '../../features/tasks/data/services/sync_status_service.dart' as _i123;
import '../../features/tasks/domain/repositories/tasks_repository.dart'
    as _i615;
import '../../features/tasks/presentation/blocs/tasks/tasks_bloc.dart' as _i688;
import '../analytics/analytics_service.dart' as _i726;
import '../analytics/composite_analytics_service.dart' as _i571;
import '../analytics/firebase_analytics_service.dart' as _i616;
import '../network/api_helper.dart' as _i938;
import '../network/mock_api_helper.dart' as _i718;
import '../network/webhook_helper.dart' as _i12;
import '../notifications/local_push_service.dart' as _i1032;
import '../services/auth_service.dart' as _i745;
import '../storage/hive_service.dart' as _i459;
import '../storage/preferences_service.dart' as _i636;
import '../storage/secure_storage_service.dart' as _i666;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i558.FlutterSecureStorage>(
      () => registerModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i616.FirebaseAnalyticsService>(
      () => _i616.FirebaseAnalyticsService(),
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i12.WebhookHelper>(() => _i12.WebhookHelper());
    gh.lazySingleton<_i745.AuthService>(() => _i745.AuthService());
    gh.lazySingleton<_i459.HiveService>(() => _i459.HiveService());
    gh.lazySingleton<_i141.SQLiteService>(() => _i141.SQLiteService());
    gh.lazySingleton<_i636.PreferencesService>(
      () => _i636.PreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1032.LocalPushService>(
      () => _i1032.LocalPushService(gh<_i636.PreferencesService>()),
    );
    gh.lazySingleton<_i726.AnalyticsService>(
      () =>
          _i571.CompositeAnalyticsService(gh<_i616.FirebaseAnalyticsService>()),
    );
    gh.lazySingleton<_i453.TasksLocalDatasource>(
      () => _i453.TasksLocalDatasource(gh<_i141.SQLiteService>()),
    );
    gh.lazySingleton<_i938.ApiHelper>(() => _i718.MockApiHelper());
    gh.lazySingleton<_i123.SyncStatusService>(
      () => _i123.SyncStatusService(gh<_i12.WebhookHelper>()),
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i547.TasksRemoteDatasource>(
      () => _i547.TasksRemoteDatasource(
        gh<_i938.ApiHelper>(),
        gh<_i123.SyncStatusService>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i745.AuthService>()),
    );
    gh.factory<_i331.AuthBloc>(
      () => _i331.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
      () => _i161.AuthRemoteDatasource(
        gh<_i938.ApiHelper>(),
        gh<_i12.WebhookHelper>(),
      ),
    );
    gh.lazySingleton<_i615.TasksRepository>(
      () => _i220.TasksRepositoryImpl(
        gh<_i547.TasksRemoteDatasource>(),
        gh<_i453.TasksLocalDatasource>(),
        gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i688.TasksBloc>(
      () => _i688.TasksBloc(gh<_i615.TasksRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

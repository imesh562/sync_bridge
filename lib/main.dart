import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_bridge/core/analytics/analytics_service.dart';
import 'package:sync_bridge/core/di/injection.dart';
import 'package:sync_bridge/core/notifications/local_push_service.dart';
import 'package:sync_bridge/flavors/flavor_config.dart';
import 'package:sync_bridge/navigation/app_router.dart';
import 'package:sync_bridge/shared/blocs/theme_cubit.dart';
import 'package:sync_bridge/shared/providers/notification_provider.dart';
import 'package:sync_bridge/shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlavorConfig.instance = FlavorConfig(
    baseUrl: 'https://jsonplaceholder.typicode.com/',
    wsUrl: 'wss://echo.websocket.org',
  );

  await configureInjection(Environment.prod);

  await Firebase.initializeApp();

  await getIt<LocalPushService>().initialize();
  await getIt<AnalyticsService>().initialize();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(getIt<SharedPreferences>())),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const _App(),
    ),
  );
}

final class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder:
          (context, child) => MaterialApp.router(
            title: 'SyncBridge',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          ),
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:sync_bridge/features/auth/presentation/pages/splash_page.dart';
import 'package:sync_bridge/shared/widgets/force_update_view.dart';
import 'package:sync_bridge/shared/widgets/maintenance_view.dart';

import 'package:sync_bridge/features/auth/presentation/pages/login_page.dart';
import 'package:sync_bridge/features/tasks/presentation/pages/tasks_view.dart';
import 'route_guards.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: RouteGuards.redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.forceUpdate,
        builder: (context, state) => const ForceUpdateView(),
      ),
      GoRoute(
        path: AppRoutes.maintenance,
        builder: (context, state) => const MaintenanceView(),
      ),
      GoRoute(
        path: AppRoutes.tasksView,
        builder: (context, state) => const TasksView(),
      ),
    ],
  );
}

abstract final class AppRoutes {
  static const splash = '/splash';
  static const forceUpdate = '/force-update';
  static const maintenance = '/maintenance';
  static const login = '/login';
  static const tasksView = '/tasks-view';
}

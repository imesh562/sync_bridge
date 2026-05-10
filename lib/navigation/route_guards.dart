import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

abstract final class RouteGuards {
  static String? redirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final path = state.uri.path;

    if (path == AppRoutes.splash) return null;
    if (path == AppRoutes.forceUpdate) return null;
    if (path == AppRoutes.maintenance) return null;

    if (!isAuthenticated && path != AppRoutes.login) return AppRoutes.login;
    if (isAuthenticated && path == AppRoutes.login) return AppRoutes.tasksView;

    return null;
  }
}

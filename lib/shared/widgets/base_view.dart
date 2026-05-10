import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_bridge/core/services/auth_service.dart';
import 'package:sync_bridge/error/failures.dart';
import 'package:sync_bridge/features/tasks/data/datasources/tasks_local_datasource.dart';
import 'package:sync_bridge/navigation/app_router.dart';
import 'package:sync_bridge/shared/blocs/base_states.dart';
import 'package:sync_bridge/shared/blocs/theme_cubit.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';

mixin BaseViewMixin<B extends BlocBase<S>, S, W extends StatefulWidget>
    on State<W> {
  late final B bloc = GetIt.instance<B>();
  late final _authService = GetIt.instance<AuthService>();
  late final _local = GetIt.instance<TasksLocalDatasource>();

  bool _loadingShowing = false;
  StreamSubscription<S>? _stateSub;

  void onState(BuildContext context, S state) {}

  @override
  void initState() {
    super.initState();
    _stateSub = bloc.stream.listen(_onState);
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    super.dispose();
  }

  void _onState(S state) {
    if (!mounted) return;
    if (state is AppLoadingState) {
      _showLoader();
    } else {
      _dismissLoader();
    }
    if (state is FailureState) {
      _handleFailure((state as FailureState).failure);
    }
    onState(context, state);
  }

  // ── Loader ───────────────────────────────────────────────────────────────

  void _showLoader() {
    if (_loadingShowing) return;
    _loadingShowing = true;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (ctx, a1, a2, child) {
        return PopScope(
          canPop: false,
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(
                                ctx,
                              ).extension<AppColorScheme>()!.surface,
                        ),
                        child: CupertinoActivityIndicator(
                          color:
                              Theme.of(
                                ctx,
                              ).extension<AppColorScheme>()!.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  void _dismissLoader() {
    if (!_loadingShowing) return;
    _loadingShowing = false;
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }

  // ── Failure handling ─────────────────────────────────────────────────────

  void _handleFailure(Failure failure) {
    if (!mounted) return;
    switch (failure) {
      case UnAuthorizedFailure():
        logOut();
      case ForceUpdateFailure():
        context.go(AppRoutes.forceUpdate);
      case MaintenanceFailure():
        context.go(AppRoutes.maintenance);
      case NetworkFailure():
        _showSnackBar('No internet connection. Please try again.');
      default:
        _showSnackBar(failure.message);
    }
  }

  Future<void> logOut() async {
    await _authService.signOut();
    if (!mounted) return;
    _local.clearAll();
    context.read<ThemeCubit>().reset();
    context.go(AppRoutes.login);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

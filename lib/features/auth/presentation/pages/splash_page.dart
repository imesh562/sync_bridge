import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_bridge/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sync_bridge/navigation/app_router.dart';
import 'package:sync_bridge/shared/widgets/base_view.dart';
import 'package:sync_bridge/utils/app_images.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with BaseViewMixin<AuthBloc, AuthState, SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void onState(BuildContext context, AuthState state) {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        body: Center(child: Image.asset(AppImages.appIcon, height: 80.h)),
      ),
    );
  }
}

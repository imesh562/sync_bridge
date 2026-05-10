import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_bridge/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sync_bridge/navigation/app_router.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';
import 'package:sync_bridge/shared/widgets/base_view.dart';
import 'package:sync_bridge/utils/extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with BaseViewMixin<AuthBloc, AuthState, LoginPage> {
  @override
  void onState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.go(AppRoutes.tasksView);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLoading = bloc.state is AuthLoading;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to\nSyncBridge',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize32,
                  fontWeight: FontWeight.bold,
                  color: colors.onBackground,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize16,
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: 64.h),

              OutlinedButton.icon(
                icon: Icon(Icons.g_mobiledata, size: 28.sp),
                label: Text(
                  'Continue with Google',
                  style: TextStyle(fontSize: AppDimensions.kFontSize16),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () => bloc.add(const GoogleSignInStarted()),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

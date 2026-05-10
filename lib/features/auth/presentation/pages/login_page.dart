import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_bridge/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sync_bridge/navigation/app_router.dart';
import 'package:sync_bridge/shared/widgets/base_view.dart';

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
    final isLoading = bloc.state is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to\nSyncBridge',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 64),

              OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () => bloc.add(const GoogleSignInStarted()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

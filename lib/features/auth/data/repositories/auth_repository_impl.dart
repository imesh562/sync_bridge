import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sync_bridge/core/services/auth_service.dart';
import 'package:sync_bridge/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<UserCredential> signInWithGoogle() async {
    return _authService.signInWithGoogle();
  }
}

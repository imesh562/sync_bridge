import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sync_bridge/error/failures.dart';
import 'package:sync_bridge/features/auth/domain/repositories/auth_repository.dart';
import 'package:sync_bridge/shared/blocs/base_states.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(AuthInitial()) {
    on<GoogleSignInStarted>(_onGoogleSignIn);
  }

  final AuthRepository _repository;

  Future<void> _onGoogleSignIn(
    GoogleSignInStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repository.signInWithGoogle();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(AppFailure(e.toString())));
    }
  }
}

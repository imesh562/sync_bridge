part of 'auth_bloc.dart';

// <<EVENTS>>
abstract base class AuthEvent extends Equatable {
  const AuthEvent();
}

final class GoogleSignInStarted extends AuthEvent {
  const GoogleSignInStarted();
  @override
  List<Object?> get props => [];
}

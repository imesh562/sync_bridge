part of 'auth_bloc.dart';

// <<STATES>>
abstract base class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => const [];
}

final class AuthSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthFailure extends AuthState with FailureState {
  const AuthFailure(this.failure);

  @override
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// Single shared loading state for this BLoC.
/// Emitted by every REST endpoint handler before the API call.
/// [BaseViewMixin] detects [AppLoadingState] and shows the loading overlay.
final class AuthLoading extends AuthState with AppLoadingState {
  const AuthLoading();

  @override
  List<Object?> get props => const [];
}

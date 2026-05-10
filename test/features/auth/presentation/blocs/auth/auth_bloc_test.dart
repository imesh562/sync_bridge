import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sync_bridge/features/auth/domain/repositories/auth_repository.dart';
import 'package:sync_bridge/features/auth/presentation/blocs/auth/auth_bloc.dart';

class _MockAuthRepository extends Mock
    implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late AuthBloc bloc;

  setUp(() {
    repository = _MockAuthRepository();
    bloc = AuthBloc(repository);
  });

  tearDown(() => bloc.close());

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(bloc.state, isA<AuthInitial>());
    });

    // TODO: add blocTest<AuthBloc, AuthState> cases for each endpoint.
    // Example:
    //
    // blocTest<AuthBloc, AuthState>(
    //   'emits [AuthLoading, LoginSuccess] when LoginStarted succeeds',
    //   build: () {
    //     when(() => repository.login(any()))
    //         .thenAnswer((_) async => const Right(LoginResponse(...)));
    //     return bloc;
    //   },
    //   act: (b) => b.add(LoginStarted(const LoginRequest(...))),
    //   expect: () => [
    //     isA<AuthLoading>(),
    //     isA<LoginSuccess>(),
    //   ],
    // );
  });
}

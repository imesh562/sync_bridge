import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sync_bridge/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:sync_bridge/features/tasks/presentation/blocs/tasks/tasks_bloc.dart';

class _MockTasksRepository extends Mock
    implements TasksRepository {}

void main() {
  late TasksRepository repository;
  late TasksBloc bloc;

  setUp(() {
    repository = _MockTasksRepository();
    bloc = TasksBloc(repository);
  });

  tearDown(() => bloc.close());

  group('TasksBloc', () {
    test('initial state is TasksInitial', () {
      expect(bloc.state, isA<TasksInitial>());
    });

    // TODO: add blocTest<TasksBloc, TasksState> cases for each endpoint.
    // Example:
    //
    // blocTest<TasksBloc, TasksState>(
    //   'emits [TasksLoading, LoginSuccess] when LoginStarted succeeds',
    //   build: () {
    //     when(() => repository.login(any()))
    //         .thenAnswer((_) async => const Right(LoginResponse(...)));
    //     return bloc;
    //   },
    //   act: (b) => b.add(LoginStarted(const LoginRequest(...))),
    //   expect: () => [
    //     isA<TasksLoading>(),
    //     isA<LoginSuccess>(),
    //   ],
    // );
  });
}

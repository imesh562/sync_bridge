import 'package:sync_bridge/error/failures.dart';

mixin AppLoadingState {}

mixin FailureState {
  Failure get failure;
  String get message => failure.message;
}

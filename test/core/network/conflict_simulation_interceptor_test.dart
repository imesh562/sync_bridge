import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sync_bridge/core/network/conflict_simulation_interceptor.dart';

class _MockHandler extends Mock implements ResponseInterceptorHandler {}

Response<dynamic> _response({required String method, required String path}) {
  final options = RequestOptions(path: path, method: method);
  return Response<dynamic>(requestOptions: options, statusCode: 200);
}

void main() {
  late ConflictSimulationInterceptor interceptor;
  late _MockHandler handler;

  setUpAll(() {
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '')),
    );
  });

  setUp(() {
    interceptor = ConflictSimulationInterceptor();
    handler = _MockHandler();
  });

  group('ConflictSimulationInterceptor', () {
    test('passes through PUT response for a non-conflict task ID', () {
      final response = _response(method: 'PUT', path: '/todos/5');

      interceptor.onResponse(response, handler);

      verify(() => handler.next(response)).called(1);
      verifyNever(() => handler.reject(any(), any()));
    });

    test('rejects with 409 for a conflict task ID', () {
      final response = _response(method: 'PUT', path: '/todos/7');

      interceptor.onResponse(response, handler);

      final captured =
          verify(() => handler.reject(captureAny(), any())).captured;
      final exception = captured.first as DioException;
      expect(exception.response?.statusCode, equals(409));
    });

    test('passes through response for non-PUT requests on conflict task IDs', () {
      final response = _response(method: 'GET', path: '/todos/7');

      interceptor.onResponse(response, handler);

      verify(() => handler.next(response)).called(1);
      verifyNever(() => handler.reject(any(), any()));
    });

    test('passes through response for PUT to a non-todos path', () {
      final response = _response(method: 'PUT', path: '/users/7');

      interceptor.onResponse(response, handler);

      verify(() => handler.next(response)).called(1);
      verifyNever(() => handler.reject(any(), any()));
    });
  });
}

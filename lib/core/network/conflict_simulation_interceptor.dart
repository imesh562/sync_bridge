import 'package:dio/dio.dart';

class ConflictSimulationInterceptor extends Interceptor {
  static const _conflictTaskIds = {7, 9, 3};

  int? _extractTaskId(RequestOptions options) {
    if (options.method != 'PUT') return null;
    final uri = options.uri.toString();
    final match = RegExp(r'/todos/(\d+)$').firstMatch(uri);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    final taskId = _extractTaskId(options);

    if (taskId == null || !_conflictTaskIds.contains(taskId)) {
      handler.next(response);
      return;
    }

    final body = options.data as Map<String, dynamic>? ?? {};

    handler.reject(
      DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 409,
          data: {
            'message': 'Conflict: server data is newer [simulated]',
            ...body,
          },
        ),
        type: DioExceptionType.badResponse,
      ),
      true,
    );
  }
}

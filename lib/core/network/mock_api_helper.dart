import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:sync_bridge/error/exceptions.dart';

import 'api_helper.dart';
import 'mock_config.dart';
import 'mock_responses.dart';

@LazySingleton(as: ApiHelper)
final class MockApiHelper extends ApiHelper {
  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!kUseMockApi)
      return super.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    return _mock('GET', path);
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    if (!kUseMockApi) return super.post(path, data: data, options: options);
    return _mock('POST', path);
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    if (!kUseMockApi) return super.put(path, data: data, options: options);
    return _mock('PUT', path);
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    if (!kUseMockApi) return super.patch(path, data: data, options: options);
    return _mock('PATCH', path);
  }

  @override
  Future<Response<T>> delete<T>(String path, {Options? options}) async {
    if (!kUseMockApi) return super.delete(path, options: options);
    return _mock('DELETE', path);
  }

  Response<T> _mock<T>(String method, String path) {
    final data = kMockResponses['$method $path'];
    if (data is Map && data['success'] == false) {
      throw ServerException(data['message'] as String? ?? 'Request failed');
    }
    return Response<T>(
      data: data as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sync_bridge/core/network/conflict_simulation_interceptor.dart';
import 'package:sync_bridge/error/exceptions.dart';
import 'package:sync_bridge/flavors/flavor_config.dart';

import 'network_config.dart';

class ApiHelper {
  ApiHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.instance.baseUrl,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        sendTimeout: NetworkConfig.sendTimeout,
      ),
    );
    _dio.interceptors.addAll([
      _authInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
      ConflictSimulationInterceptor(),
    ]);
  }

  late final Dio _dio;
  static const _storage = FlutterSecureStorage();

  /// Injects the stored auth token into every outgoing request.
  /// Token is read from the device secure keychain / keystore.
  Interceptor _authInterceptor() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw mapHttpError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw mapHttpError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw mapHttpError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw mapHttpError(e);
    }
  }

  Future<Response<T>> delete<T>(String path, {Options? options}) async {
    try {
      final response = await _dio.delete<T>(path, options: options);
      return response;
    } on DioException catch (e) {
      throw mapHttpError(e);
    }
  }
}

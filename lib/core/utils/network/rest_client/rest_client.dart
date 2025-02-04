import 'dart:async';

import 'package:dio/dio.dart';
import 'package:feedback_work/core/constants/api_endpoints.dart';
import 'package:feedback_work/core/utils/network/api_client_exception.dart';
import 'package:feedback_work/core/utils/network/rest_client/interceptor.dart';
import 'package:feedback_work/core/utils/network/utils/pretty_dio_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension IsOk on Response<dynamic> {
  bool get ok {
    return (statusCode! ~/ 100) == 2;
  }
}

enum ApiAccessType {
  protected,
  public,
}

final stripePublishableKeyProvider = StateProvider<String>((ref) {
  return '';
});

final stripeSecretKeyProvider = StateProvider<String>((ref) {
  return '';
});

final stripePaymentAPIProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiEndpoints.stripeBaseUrl,
    // TODO(eltanvir): Porvide a stream of idToken
    idToken: ref.watch(stripeSecretKeyProvider.notifier).state,
    // TODO(eltanvir): Provide a function to refresh the idToken
    refreshIdToken: () async {
      return null;
    },
  );
});

class ApiClient {
  ApiClient({
    required String baseUrl,
    required Future<String?> Function() refreshIdToken,
    required String idToken,
  }) : _idToken = idToken {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    _client = Dio(options)
      ..interceptors.addAll(
        [
          AuthInterceptor(refreshIdToken: refreshIdToken),
          PrettyDioLogger(requestHeader: true, requestBody: true),
        ], // Custom interceptor
      );
  }

  late final Dio _client;
  late final StreamSubscription<String?> _idTokenSubscription;
  late final String _idToken;

  Map<String, String> get _headers => {
        if (_idToken != '') 'Authorization': "Bearer $_idToken",
        'Accept': 'application/json',
        // 'Content-type': 'application/x-www-form-urlencoded',
      };

  void _cancelIfUnauthorized(ApiAccessType accessType) {
    if (accessType == ApiAccessType.protected && _idToken == '') {
      throw AppError(
        'Unauthorized -> Request Cancelled:'
        '\nUnauthorized user requested a protected resource.',
        stackTrace: StackTrace.current,
      );
    }
  }

  /// Dispose of resources used by this client.
  Future<void> dispose() async {
    await _idTokenSubscription.cancel();
  }

  /// Sends a POST request to the specified [path] with the given [body].
  // ignore: strict_raw_type
  Future<Response> post(
    ApiAccessType accessType,
    String path,
    Map<String, dynamic>? body, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    // ignore: strict_raw_type, inference_failure_on_function_invocation
    final response = await _client.post(
      path,
      data: body,
      // data: FormData.fromMap({...(body ?? {})}),
      options: Options(headers: {..._headers, ...?headers}),
      queryParameters: queryParams,
    );
    return response;
  }

  /// Sends a POST request with FormData to the specified [path].
  // ignore: strict_raw_type
  Future<Response> postFormData(
    ApiAccessType accessType,
    String path,
    Map<String, dynamic>? body, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    // ignore: strict_raw_type, inference_failure_on_function_invocation
    final response = await _client.post(
      path,
      data: FormData.fromMap({...(body ?? {}), 'returnJson': 1}),
      options: Options(
        headers: {
          ..._headers,
          ...?headers,
          'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: queryParams,
    );
    return response;
  }

  /// Sends a PATCH request to the specified [path] with the given [body].
  Future<Response<dynamic>> patch(
    ApiAccessType accessType,
    String path,
    Object body, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    final response = await _client.patch<Response<dynamic>>(
      path,
      data: body,
      options: Options(headers: {..._headers, ...?headers}),
      queryParameters: queryParams,
    );
    return response;
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<Response<dynamic>> put(
    ApiAccessType accessType,
    String path,
    Object? body, {
    Map<String, dynamic>? headers,
  }) async {
    _cancelIfUnauthorized(accessType);
    final response = await _client.put<Response<dynamic>>(
      path,
      data: body,
      options: Options(headers: {..._headers, ...?headers}),
    );
    return response;
  }

  /// Sends a DELETE request to the specified [path] with the given [body].
  Future<Response<dynamic>> delete(
    ApiAccessType accessType,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    final response = await _client.delete<Response<dynamic>>(
      path,
      data: body,
      options: Options(headers: {..._headers, ...?headers}),
      queryParameters: queryParams,
    );
    return response;
  }

  /// Sends a GET request to the specified [path].
  Future<Response<dynamic>> get(
    ApiAccessType accessType,
    String path, {
    Map<String, String>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    final response = await _client.get<dynamic>(
      path,
      queryParameters: queryParams,
      options: Options(headers: _headers),
    );
    return response;
  }

  /// Sends a GET request to retrieve a file.
  Future<Response<dynamic>> getFile(
    ApiAccessType accessType,
    String path, {
    Map<String, String>? queryParams,
  }) async {
    _cancelIfUnauthorized(accessType);
    final response = await _client.get<dynamic>(
      path,
      queryParameters: queryParams,
      options: Options(
        headers: _headers,
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    return response;
  }
}

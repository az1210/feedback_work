import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feedback_work/core/utils/network/api_client_exception.dart';
import 'package:feedback_work/core/utils/utils.dart';

///Handles all errors that occur during the API request.
///Also, it refreshes the token if the request is unauthorized.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.refreshIdToken,
  });

  final Future<String?> Function() refreshIdToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      return handler.next(options); // Proceed with the request
    } catch (error) {
      handler.reject(
        DioException(requestOptions: options, error: _getDioException(error)),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If the request was unauthorized (401)
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        final newIdToken = await refreshIdToken();
        if (newIdToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newIdToken';
          if (err.requestOptions.data is FormData) {
            err.requestOptions.data =
                (err.requestOptions.data as FormData).clone();
          }
          return handler.resolve(await Dio().fetch(err.requestOptions));
        } else {
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AppError('Failed to refresh token.'),
            ),
          );
        }
      } catch (e, stackTrace) {
        Log.error(e.toString());
        Log.error(stackTrace.toString());
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: _getDioException(e),
          ),
        );
      }
    } else {
      Log.error(err.toString());
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: _getDioException(err),
        ),
      );
    }
  }

  dynamic _getDioException(dynamic error) {
    if (error is DioException) {
      _dioError(error);
    } else {
      throw AppError(
        'An unexpected error occurred.',
      );
    }
  }

  void _dioError(DioException error) {
    Log.error('Error: $error \nStackTrace: ${error.stackTrace}');
    final endpoint =
        'ENDPOINT: ${error.requestOptions.baseUrl}${error.requestOptions.path}';
    switch (error.type) {
      case DioExceptionType.cancel:
        throw AppError('Request was cancelled. $endpoint');

      case DioExceptionType.connectionTimeout:
        throw AppError(
          'Connection timeout. $endpoint',
        );

      case DioExceptionType.unknown:
        _networkException(
          _getErrorMessage(error),
          error.response?.statusCode,
          error.response?.statusMessage ?? '',
        );

      case DioExceptionType.receiveTimeout:
        throw AppError(
          'Receive timeout occurred. $endpoint',
        );

      case DioExceptionType.sendTimeout:
        throw AppError(
          'Send timeout occurred. $endpoint',
        );

      case DioExceptionType.badCertificate:
        throw AppError(
          'Bad certificate encountered. $endpoint',
        );

      case DioExceptionType.badResponse:
        _networkException(
          _getErrorMessage(error),
          error.response?.statusCode,
          error.response?.statusMessage ?? '',
        );
      case DioExceptionType.connectionError:
        _networkException(
          _getErrorMessage(error),
          error.response?.statusCode,
          error.response?.statusMessage ?? '',
        );
    }
  }

  /// Parses error messages from Dio responses based on different formats.
  ///
  /// The method supports the following formats:
  /// 1. When `response.data` is `null`, it returns the error message
  ///    from Dio (`error.message`).
  /// 2. When `response.data` is a plain string, it returns that string.
  /// 3. When `response.data` contains a `message` field,
  ///    it returns the message if:
  ///    - `message` is a string.
  ///    - `message` is a map containing a list of error messages,
  ///    and the first message is extracted.
  ///
  /// Returns an empty string if no recognizable message is found.
  ///
  /// Example formats:
  /// ```
  /// { "message": "Error occurred" }
  /// { "message": { "errors": ["First error message"] } }
  /// ```
  String _getErrorMessage(DioException error) {
    if (error.response?.data == null) {
      return error.message ?? '';
    } else if (error.response?.data is String) {
      return error.response?.data as String;
    } else if (error.response?.data is Map<String, dynamic>) {
      final data = error.response?.data as Map<String, dynamic>;

      if (data.containsKey('message')) {
        final messageData = data['message'];

        if (messageData is String) {
          return messageData;
        } else if (messageData is Map<String, dynamic>) {
          // Access the first error message if it's a map of lists
          final firstError =
              (messageData.values.first as List<dynamic>).first as String;
          return firstError;
        }
      }
    }
    return '';
  }

  void _networkException(
    String errorModel,
    int? statusCode,
    String message,
  ) {
    switch (statusCode) {
      case 400:
        throw AppError(
          'Bad request: $message',
        );
      case 403:
        throw AppError(
          'Forbidden: $message',
        );
      case 401:
        throw AppError(
          'Unauthorized: $message',
        );
      case 404:
        throw AppError(
          'Not found: $message',
        );
      case 409:
        throw AppError(
          'Conflict: $message',
        );
      case 422:
        throw AppError(
          'Unprocessable entity: $message',
        );
      case 500:
        throw AppError(
          'Internal server error: $message',
        );
      case 502:
        throw AppError(
          'Bad gateway: $message',
        );
      default:
        throw AppError(
          'Network error: $message',
        );
    }
  }
}

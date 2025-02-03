// ignore_for_file: type_annotate_public_apis, avoid_dynamic_calls, duplicate_ignore

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

///Network Exceptions
@freezed
abstract class AppExceptions with _$AppExceptions {
  ///Exception for Firebase
  const factory AppExceptions.firebaseException(String reason) = FBaseException;

  ///Exception for Request Cancelled
  const factory AppExceptions.requestCancelled() = RequestCancelled;

  ///Exception for Temporary Moved 302
  const factory AppExceptions.temporayMoved() = TemporayMoved;

  ///Exception for Bad Request 400
  const factory AppExceptions.badRequest() = BadRequest;

  ///Exception for Unauthorised Request 401
  const factory AppExceptions.unauthorisedRequest() = UnauthorisedRequest;

  ///Exception for Forbidden Request 402
  const factory AppExceptions.forbidden() = ForbiddenRequest;

  ///Exception for Not Found 404
  const factory AppExceptions.notFound(String reason) = NotFound;

  ///Exception for Method Not Allowed 405
  const factory AppExceptions.methodNotAllowed() = MethodNotAllowed;

  ///Exception for Not Acceptable 406
  const factory AppExceptions.notAcceptable() = NotAcceptable;

  ///Exception for Request Timeout 408
  const factory AppExceptions.requestTimeout() = RequestTimeout;

  ///Exception for Conflict 409
  const factory AppExceptions.conflict() = Conflict;

  ///Exception for removed permanently 410
  const factory AppExceptions.removedPermanently() = RemovedPermanently;

  ///Exception for length required 411
  const factory AppExceptions.lengthRequired() = LengthRequired;

  ///Exception for precondition Failed 412
  const factory AppExceptions.preConditionFailed() = PreconditionsFailed;

  ///Exception for payload too large 413
  const factory AppExceptions.payloadTooLarge() = PayloadTooLarge;

  ///Exception for URI too long 414
  const factory AppExceptions.uriTooLPong() = UriTooLong;

  ///Exception for Unsupported Media Type 415
  const factory AppExceptions.unSupportedMediaType() = UnSupportedMediaType;

  ///Exception for Range Not Satisfiable 416
  const factory AppExceptions.rangeNotSatisfiable() = RangeNotSatisfiable;

  ///Exception for Expectation Failed 417
  const factory AppExceptions.expectationFailed() = ExpectationFailed;

  ///Exception for Unprocessable Entity 422
  const factory AppExceptions.unprocessableEntity() = UnprocessableEntity;

  ///Exception for Too Many Requests 429
  const factory AppExceptions.tooManyRequests() = TooManyRequests;

  ///Exception for Server Error 500
  const factory AppExceptions.internalServerError() = InternalServerError;

  ///Exception for Unimplemented 501
  const factory AppExceptions.notImplemented() = NotImplemented;

  ///Exception for Bad Gateway 502
  const factory AppExceptions.badGetWay() = BadGetWay;

  ///Exception for Service Unavailable 503
  const factory AppExceptions.serviceUnavailable() = ServiceUnavailable;

  ///Exception for Gateway Timeout 504
  const factory AppExceptions.noInternetConnection() = NoInternetConnection;

  ///Exception for Wrong Data Format
  const factory AppExceptions.formatException() = FormatException;

  ///Exception for Send Timeout
  const factory AppExceptions.sendTimeout() = SendTimeout;

  ///Exception for Default Error
  const factory AppExceptions.defaultError(String error) = DefaultError;

  ///Exception for Unexpected Error
  const factory AppExceptions.unexpectedError() = UnexpectedError;

  ///Method To Get Error Message
  static String generateErrorMsg(AppExceptions networkExceptions) {
    var errorMessage = '';
    networkExceptions.when(
      notImplemented: () {
        errorMessage = 'Not Implemented';
      },
      requestCancelled: () {
        errorMessage = 'Request Cancelled';
      },
      internalServerError: () {
        errorMessage = 'Internal Server Error';
      },
      notFound: (String reason) {
        errorMessage = reason;
      },
      serviceUnavailable: () {
        errorMessage = 'Service unavailable';
      },
      methodNotAllowed: () {
        errorMessage = 'Method Allowed';
      },
      badRequest: () {
        errorMessage = 'Bad request';
      },
      unauthorisedRequest: () {
        errorMessage = 'Unauthorised request';
      },
      unexpectedError: () {
        errorMessage = 'Unexpected error occurred';
      },
      requestTimeout: () {
        errorMessage = 'Connection request timeout';
      },
      noInternetConnection: () {
        errorMessage = 'No internet connection';
      },
      conflict: () {
        errorMessage = 'Error due to a conflict';
      },
      sendTimeout: () {
        errorMessage = 'Send timeout in connection with API server';
      },
      unSupportedMediaType: () {
        errorMessage = 'Unsupported media type';
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      formatException: () {
        errorMessage = 'Fromat Error';
      },
      notAcceptable: () {
        errorMessage = 'Not acceptable';
      },
      firebaseException: (String reason) {
        errorMessage = reason;
      },
      forbidden: () {
        errorMessage = 'Forbidden';
      },
      removedPermanently: () {
        errorMessage = 'Removed Permanently';
      },
      lengthRequired: () {
        errorMessage = 'Length Required';
      },
      preConditionFailed: () {
        errorMessage = 'Precondition Failed';
      },
      payloadTooLarge: () {
        errorMessage = 'Payload Too Large';
      },
      uriTooLPong: () {
        errorMessage = 'URI Too Long';
      },
      rangeNotSatisfiable: () {
        errorMessage = 'Range Not Satisfiable';
      },
      expectationFailed: () {
        errorMessage = 'Expectation Failed';
      },
      unprocessableEntity: () {
        errorMessage = 'Unprocessable Entity';
      },
      tooManyRequests: () {
        errorMessage = 'Too Many Requests';
      },
      badGetWay: () {
        errorMessage = 'Bad GetWay';
      },
      temporayMoved: () {
        errorMessage = 'Temporay Moved';
      },
    );
    return errorMessage;
  }

  ///Takes any Error And Returns Corresponding Message
  static String errorText(dynamic error) {
    final data = generateErrorMsg(getDioException(error));
    return data;
  }

  ///Takes error and Returns Network Exception
  // ignore: prefer_constructors_over_static_methods
  static AppExceptions getDioException(dynamic error) {
    if (error is Exception) {
      try {
        AppExceptions networkExceptions;
        if (error is DioException) {
          String? msg;
          final errorResponse = error.response?.data;
          if (errorResponse != null) {
            if (errorResponse['response'] is String) {
              msg = errorResponse['response'] as String;
            } else if (errorResponse['response'] is Map<String, dynamic>) {
              final xerror =
                  error.response?.data['response'] as Map<String, dynamic>;
              // ignore: cascade_invocations
              xerror.forEach((key, value) {
                if (msg == null) {
                  msg = value.first as String;
                } else {
                  msg = '$msg\n${value.first}';
                }
              });
            }
          }

          if (msg != null) {
            return AppExceptions.defaultError(msg!);
          }

          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const AppExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const AppExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions = const AppExceptions.unexpectedError();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const AppExceptions.requestTimeout();
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 302:
                  networkExceptions = const AppExceptions.temporayMoved();
                  break;
                case 400:
                  networkExceptions = const AppExceptions.badRequest();
                  break;
                case 401:
                  networkExceptions = const AppExceptions.unauthorisedRequest();
                  break;
                case 403:
                  networkExceptions = const AppExceptions.forbidden();
                  break;
                case 404:
                  networkExceptions = const AppExceptions.notFound('Not found');
                  break;
                case 405:
                  networkExceptions = const AppExceptions.methodNotAllowed();
                  break;
                case 406:
                  networkExceptions = const AppExceptions.notAcceptable();
                  break;
                case 408:
                  networkExceptions = const AppExceptions.requestTimeout();
                  break;
                case 409:
                  networkExceptions = const AppExceptions.conflict();
                  break;
                case 410:
                  networkExceptions = const AppExceptions.removedPermanently();
                  break;
                case 411:
                  networkExceptions = const AppExceptions.lengthRequired();
                  break;
                case 412:
                  networkExceptions = const AppExceptions.preConditionFailed();
                  break;
                case 413:
                  networkExceptions = const AppExceptions.payloadTooLarge();
                  break;

                case 414:
                  networkExceptions = const AppExceptions.uriTooLPong();
                  break;
                case 415:
                  networkExceptions =
                      const AppExceptions.unSupportedMediaType();
                  break;
                case 416:
                  networkExceptions = const AppExceptions.rangeNotSatisfiable();
                  break;
                case 417:
                  networkExceptions = const AppExceptions.expectationFailed();
                  break;
                case 422:
                  networkExceptions = const AppExceptions.unprocessableEntity();
                  break;
                case 429:
                  networkExceptions = const AppExceptions.tooManyRequests();
                  break;
                case 500:
                  networkExceptions = const AppExceptions.internalServerError();
                  break;
                case 501:
                  networkExceptions = const AppExceptions.notImplemented();
                  break;
                case 502:
                  networkExceptions = const AppExceptions.badGetWay();
                  break;
                case 503:
                  networkExceptions = const AppExceptions.serviceUnavailable();
                  break;
                case 504:
                  networkExceptions =
                      const AppExceptions.noInternetConnection();
                  break;
                default:
                  final responseCode = error.response!.statusCode;
                  networkExceptions = AppExceptions.defaultError(
                    'Received invalid status code: $responseCode',
                  );
              }
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const AppExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const AppExceptions.unexpectedError();
              break;
            case DioExceptionType.connectionError:
              networkExceptions = const AppExceptions.noInternetConnection();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const AppExceptions.noInternetConnection();
        } else {
          networkExceptions = const AppExceptions.unexpectedError();
        }
        return networkExceptions;
        // ignore: unused_catch_clause
      } on FormatException catch (e) {
        // Helper.printError(e.toString());
        return const AppExceptions.formatException();
      } catch (_) {
        return const AppExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return const AppExceptions.formatException();
      } else {
        return const AppExceptions.unexpectedError();
      }
    }
  }
}

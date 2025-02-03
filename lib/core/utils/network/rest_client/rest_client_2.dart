// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:feedback_work/core/constants/api_endpoints.dart';
// import 'package:feedback_work/core/utils/cache_service/cache_service.dart';
// import 'package:feedback_work/core/utils/network/utils/pretty_dio_logger.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// part 'api_options.dart';

// final restClientProviderForStripe = Provider<RestClient>((ref) {
//   return RestClient(
//       baseUrl: ApiEndpoints.stripeBaseUrl,
//       cacheService: ref.watch(cacheServiceProvider));
// });

// ///Rest Client for API calls
// class RestClient {
//   ///
//   factory RestClient({
//     required String baseUrl,
//     int connectionTimeout = 30000,
//     int receiveTimeout = 30000,
//     String? refreshTokenUrl,
//     String Function(Map<String, dynamic>)? onTokenRefresh,
//     required CacheService cacheService,
//   }) {
//     _instance.baseUrl = baseUrl;
//     _instance.connectionTimeout = connectionTimeout;
//     _instance.receiveTimeout = receiveTimeout;
//     _instance.refreshTokenUrl = refreshTokenUrl;

//     final options = BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: Duration(milliseconds: connectionTimeout),
//       receiveTimeout: Duration(milliseconds: receiveTimeout),
//     );

//     _instance._dio = Dio(options);

//     _instance._dio.interceptors.add(
//       DynamicInterceptor(
//         baseUrl: baseUrl,
//         refreshTokenUrl: refreshTokenUrl,
//         onTokenRefresh: onTokenRefresh,
//         cacheService: cacheService,
//       ),
//     );
//     if (kDebugMode) {
//       _instance._dio.interceptors.add(PrettyDioLogger());
//     }
//     return _instance;
//   }

//   RestClient._internal();
//   static final RestClient _instance = RestClient._internal();

//   ///Url to refresh token
//   late String? refreshTokenUrl;

//   late Dio _dio;

//   ///[connectionTimeout] is the connection timeout for the API calls
//   late int connectionTimeout;

//   ///[receiveTimeout] is the receive timeout for the API calls
//   late int receiveTimeout;

//   ///[baseUrl] is the base url for the API calls
//   late String baseUrl;

//   ///make a get request
//   Future<Response<dynamic>> get(
//     APIType apiType,
//     String path, {
//     Map<String, dynamic>? query,
//     Map<String, dynamic>? headers,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);

//     return _dio.get<dynamic>(
//       path,
//       queryParameters: query,
//       options: standardHeaders,
//     );
//   }

//   ///make a post request
//   Future<Response<dynamic>> post(
//     APIType apiType,
//     String path,
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);
//     if (headers != null) {
//       standardHeaders.headers?.addAll(headers);
//     }

//     return _dio.post<dynamic>(
//       path,
//       data: data,
//       options: standardHeaders,
//       queryParameters: query,
//     );
//   }

//   /// Supports media upload
//   Future<Response<dynamic>> postFormData(
//     APIType apiType,
//     String path,
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);
//     standardHeaders.headers?.addAll({
//       'Content-Type': 'multipart/form-data',
//     });

//     return _dio.post<dynamic>(
//       path,
//       data: FormData.fromMap(data),
//       options: standardHeaders,
//       queryParameters: query,
//     );
//   }

//   ///make a patch request
//   Future<Response<dynamic>> patch(
//     APIType api,
//     String path,
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(api);
//     if (headers != null) {
//       standardHeaders.headers?.addAll(headers);
//     }

//     return _dio.patch<dynamic>(
//       path,
//       data: data,
//       options: standardHeaders,
//       queryParameters: query,
//     );
//   }

//   ///make a put request
//   Future<Response<dynamic>> put(
//     APIType apiType,
//     String path,
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);
//     if (headers != null) {
//       standardHeaders.headers?.addAll(headers);
//     }

//     return _dio.put<dynamic>(
//       path,
//       data: data,
//       options: standardHeaders,
//     );
//   }

//   ///make a delete request
//   Future<Response<dynamic>> delete(
//     APIType apiType,
//     String path, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);
//     if (headers != null) {
//       standardHeaders.headers?.addAll(headers);
//     }

//     return _dio.delete<dynamic>(
//       path,
//       data: data,
//       queryParameters: query,
//       options: standardHeaders,
//     );
//   }

//   /// Supports media upload
//   Future<Response<dynamic>> putFormData(
//     APIType apiType,
//     String path,
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? query,
//   }) async {
//     // _setDioInterceptorList();

//     final standardHeaders = await _getOptions(apiType);
//     if (headers != null) {
//       standardHeaders.headers?.addAll({
//         'Content-Type': 'multipart/form-data',
//       });
//     }
//     data.addAll({
//       '_method': 'PUT',
//     });

//     return _dio.post<dynamic>(
//       path,
//       data: FormData.fromMap(data),
//       queryParameters: query,
//       options: standardHeaders,
//     );
//   }

//   ///Upload Media to s3 bucket
//   Future<Response<dynamic>> fileUploadInS3Bucket({
//     required String preAssignedUrl,
//     required File file,
//   }) async {
//     return _dio.put(
//       preAssignedUrl,
//       data: file.openRead(),
//       options: Options(
//         headers: {
//           Headers.contentLengthHeader: await file.length(),
//         },
//       ),
//     );
//   }

//   Future<Options> _getOptions(APIType api) async {
//     switch (api) {
//       case APIType.public:
//         return PublicApiOptions().options;
//       case APIType.private:
//         return ProtectedApiOptions().options;
//     }
//   }
// }

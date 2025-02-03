import 'package:dio/dio.dart';

///[APIType.public] => Generic API url without access token
///PROTECTED => Generic API url with access token
enum APIType {
  ///[APIType.public] Means the API is public and doesn't require
  ///any access token
  public,

  ///[APIType.public] Means the API is Private and requires access token
  private,
}

///[ApiOptions] is the base class for [PublicApiOptions]
///and [ProtectedApiOptions]
abstract class ApiOptions {
  ///[options] is the base dio options for all API calls
  Options options = Options();
}

///[PublicApiOptions] is the Implementation of [ApiOptions]
///for public API calls
class PublicApiOptions extends ApiOptions {
  ///[PublicApiOptions] adds default headers for public API calls
  PublicApiOptions() {
    super.options = options.copyWith(
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      extra: <String, dynamic>{
        'requiresToken': false,
      },
    );
  }
}

///[ProtectedApiOptions] is the Implementation of [ApiOptions]
///for protected API calls
class ProtectedApiOptions extends ApiOptions {
  ///[ProtectedApiOptions] adds default headers for protected API calls
  ///and adds the access token to the header
  ProtectedApiOptions() {
    super.options = options.copyWith(
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      extra: <String, dynamic>{
        'requiresToken': true,
      },
    );
  }
}

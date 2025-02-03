part of 'cache_service.dart';

final cacheServiceProvider = Provider<CacheServiceImpl>(
  (ref) => CacheServiceImpl(box: Hive.box('feedbackWorks')),
);

///[CacheServiceImpl] is the Implementation of [CacheService]
class CacheServiceImpl implements CacheService {
  ///[CacheServiceImpl] is a singleton class
  CacheServiceImpl({required Box<dynamic> box}) {
    init(newbox: box);
  }

  ///Box for storing data
  late Box<dynamic> box;

  static const String _isLoggedIn = 'isLoggedIn';
  static const String _bearerToken = 'bearerToken';
  static const String _refreshToken = 'refreshToken';
  static const String _fcmToken = 'fcmToken';

  @override
  Future<void> init({required Box<dynamic> newbox}) async {
    box = newbox;
  }

  @override
  Future<bool> get isLoggedIn async =>
      await read(_isLoggedIn) as bool? ?? false;

  @override
  Future<void> setLoggedIn({required bool value}) async =>
      save(_isLoggedIn, value);

  @override
  Future<String?> get bearerToken async {
    return await read(_bearerToken) as String?;
  }

  @override
  Future<void> setBearerToken(String value) async => save(_bearerToken, value);

  @override
  Future<String?> get refreshToken async =>
      await read(_refreshToken) as String?;

  @override
  Future<void> setRefreshToken(String value) async =>
      save(_refreshToken, value);

  @override
  Future<String?> get fcmToken async => await read(_fcmToken) as String?;

  @override
  Future<void> setFcmToken(String value) async => save(_fcmToken, value);

  @override
  Future<void> delete(String key) async => box.delete(key);

  @override
  Future<void> deleteAll() async => box.clear();
  @override
  Future<void> save(String key, dynamic value) async => box.put(key, value);
  @override
  Future<dynamic> read(String key) async => box.get(key);
}

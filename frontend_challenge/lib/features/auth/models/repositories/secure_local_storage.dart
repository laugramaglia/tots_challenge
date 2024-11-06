import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_local_storage.g.dart';

const _token = 'x-auth-token';

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => SecureStorage();

class SecureStorage {
  late final FlutterSecureStorage secureStorage;

  SecureStorage() {
    secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  // Token
  Future<void> setToken(String token) async {
    await secureStorage.write(key: _token, value: token);
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: _token);
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: _token);
  }
}

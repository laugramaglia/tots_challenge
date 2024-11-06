import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:frontend_challenge/features/auth/models/repositories/secure_local_storage.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository(
    secureStorage: ref.read(secureStorageProvider),
  );
}

class AuthLocalRepository {
  final SecureStorage secureStorage;
  const AuthLocalRepository({required this.secureStorage});

  Future<void> setToken(String? token) async {
    if (token == null) {
      return;
    }
    // Write value
    await secureStorage.setToken(token);
  }

  Future<String?> getToken() async {
    return await secureStorage.getToken();
  }
}

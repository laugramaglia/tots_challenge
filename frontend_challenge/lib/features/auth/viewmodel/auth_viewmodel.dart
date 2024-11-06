import 'dart:developer';

import 'package:frontend_challenge/features/auth/models/repositories/auth_local_repository.dart';
import 'package:frontend_challenge/features/auth/models/user_model.dart';
import 'package:frontend_challenge/features/auth/models/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<UserModel?> build() async {
    return Future.value(null);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await ref.read(authRemoteRepositoryProvider).login(
          email: email,
          password: password,
        );

    res.fold((l) {
      log(l.message);
      state = AsyncValue.error(
        l.message,
        StackTrace.current,
      );
    }, (r) {
      _loginSuccess(r);
    });
  }

  AsyncValue<UserModel?> _loginSuccess(UserModel user) {
    ref.read(authLocalRepositoryProvider).setToken(user.token);
    return state = AsyncValue.data(user);
  }
}

import 'package:frontend_challenge/features/auth/models/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_authenticated_provider.g.dart';

@riverpod
class IsAuthenticated extends _$IsAuthenticated {
  @override
  Future<bool> build() async => await _isAuthenticated();

  Future<void> check() async {
    state = await AsyncValue.guard(_isAuthenticated);
  }

  Future<bool> _isAuthenticated() async {
    return await ref.watch(authLocalRepositoryProvider).getToken() != null;
  }
}

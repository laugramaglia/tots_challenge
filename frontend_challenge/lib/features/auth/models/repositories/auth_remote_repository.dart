import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend_challenge/core/failure/failure.dart';
import 'package:frontend_challenge/core/network/dio_provider.dart';
import 'package:frontend_challenge/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository(
    dio: ref.read(dioProvider),
  );
}

class AuthRemoteRepository {
  final Dio dio;

  AuthRemoteRepository({required this.dio});

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/collections/users/auth-with-password',
      data: jsonEncode(
        {
          'identity': email,
          'password': password,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw AppFailure(response.data['message']);
    }
    return Either.tryCatch(() {
      Map<String, dynamic> responseBody = response.data['record'];
      responseBody.addAll({'token': response.data['token']});

      return UserModel.fromJson(responseBody);
    }, (e, s) {
      if (e is DioException) {
        return ServerFailure(e);
      }

      return AppFailure(e.toString());
    });
  }
}

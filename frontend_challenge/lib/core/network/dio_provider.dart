import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/core/constants/server_constats.dart';
import 'package:frontend_challenge/core/interseptors/jwt_dio_interseptor.dart';
import 'package:frontend_challenge/features/auth/models/repositories/secure_local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) => Dio(
      BaseOptions(
        baseUrl: Environment().baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 3),
      ),
    )..interceptors.add(
        JwtDioInterceptor(
          storage: ref.read(secureStorageProvider),
        ),
      );

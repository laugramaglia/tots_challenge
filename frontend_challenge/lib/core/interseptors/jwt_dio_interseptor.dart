import 'package:dio/dio.dart';
import 'package:frontend_challenge/features/auth/models/repositories/secure_local_storage.dart';

class JwtDioInterceptor extends Interceptor {
  final SecureStorage storage;

  bool isRefreshing = false;

  // Queue to store failed requests that will be retried after token refresh
  // final _pendingRequests = <RequestOptions>[];

  JwtDioInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await storage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If we get a 401 response, try to refresh the token
      await storage.deleteToken();
    }
    return handler.next(err);
  }

  // Future<bool> _refreshToken() async {
  //   if (isRefreshing) {
  //     return true;
  //   }

  //   isRefreshing = true;

  //   try {
  //     final refreshToken = await storage.getRefreshToken();

  //     if (refreshToken == null) {
  //       return false;
  //     }

  //     final response = await dio.post(
  //       '/auth/refresh',
  //       data: {'refresh_token': refreshToken},
  //     );

  //     if (response.statusCode == 200) {
  //       // Save new tokens
  //       await storage.setToken(
  //         response.data['access_token'],
  //       );
  //       await storage.setRefreshToken(
  //         response.data['refresh_token'],
  //       );

  //       isRefreshing = false;
  //       return true;
  //     }

  //     // If refresh failed, clear tokens and return false
  //     await _clearTokens();
  //     return false;
  //   } catch (e) {
  //     await _clearTokens();
  //     return false;
  //   } finally {
  //     isRefreshing = false;
  //   }
  // }

  // Future<void> _clearTokens() async {
  //   await storage.deleteToken();
  //   await storage.deleteRefreshToken();
  // }

  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );

  //   return dio.request<dynamic>(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }
}

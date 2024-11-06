import 'package:dio/dio.dart';

class AppFailure {
  final String message;
  AppFailure([this.message = 'Sorry, an unexpected error occurred!']);

  @override
  String toString() => 'Error: $message';
}

class ServerFailure extends AppFailure {
  ServerFailure(DioException err)
      : super(err.response?.data['message'] ?? 'Server Error');
}

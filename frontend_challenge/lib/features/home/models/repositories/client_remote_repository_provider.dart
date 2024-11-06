import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend_challenge/core/failure/failure.dart';
import 'package:frontend_challenge/core/network/dio_provider.dart';
import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/models/paginated_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_remote_repository_provider.g.dart';

@riverpod
ClientRemoteRepository clientRemoteRepository(Ref ref) {
  return ClientRemoteRepository(
    dio: ref.read(dioProvider),
  );
}

class ClientRemoteRepository {
  final Dio dio;

  ClientRemoteRepository({
    required this.dio,
  });

  Future<Either<AppFailure, PaginatedResponse<CustomerModel>>> getClients({
    int page = 1,
    int perPage = 5,
  }) async {
    final response = await dio.get(
      '/collections/clients/records',
      queryParameters: {
        'perPage': perPage,
        'page': page,
      },
    );
    return Either.tryCatch(() {
      final resBodyMap = response.data as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw AppFailure(resBodyMap['detail']);
      }

      final PaginatedResponse<CustomerModel> paginatedResponse =
          PaginatedResponse.fromJson(resBodyMap, CustomerModel.fromJson);

      return paginatedResponse;
    }, (e, s) {
      if (e is DioException) {
        return ServerFailure(e);
      }

      return AppFailure(e.toString());
    });
  }

  Future<Either<AppFailure, CustomerModel>> handleClient(CustomerModel client,
      {required ClientEnpointType type}) async {
    return switch (type) {
      ClientEnpointType.create => _createClient(client),
      ClientEnpointType.update => _updateClient(client),
      _ => _uploadFile(client, type),
    };
  }

  Future<Either<AppFailure, CustomerModel>> _createClient(
    CustomerModel client, {
    Object? data,
    Options? options,
  }) async {
    final response = await dio.post(
      '/collections/clients/records',
      data: data ?? client.toJson(),
      options: options,
    );
    return Either.tryCatch(() {
      final resBodyMap = response.data as Map<String, dynamic>; // 200

      if (response.statusCode != 200) {
        throw AppFailure(resBodyMap['detail']);
      }

      return CustomerModel.fromJson(resBodyMap);
    }, (e, s) {
      if (e is DioException) {
        return ServerFailure(e);
      }

      return AppFailure(e.toString());
    });
  }

  Future<Either<AppFailure, CustomerModel>> _updateClient(
    CustomerModel client, {
    Object? data,
    Options? options,
  }) async {
    final response = await dio.patch(
      '/collections/clients/records/${client.id}',
      data: data ?? client.toJson(),
      options: options,
    );
    return Either.tryCatch(() {
      final resBodyMap = response.data as Map<String, dynamic>; // 200

      if (response.statusCode != 200) {
        throw AppFailure(resBodyMap['detail']);
      }

      return CustomerModel.fromJson(resBodyMap);
    }, (e, s) {
      if (e is DioException) {
        return ServerFailure(e);
      }

      return AppFailure(e.toString());
    });
  }

  Future<Either<AppFailure, CustomerModel>> _uploadFile(
      CustomerModel client, ClientEnpointType type) async {
    const fieldName = 'photo';

    // Create FormData with the file
    final formData = FormData.fromMap(client.toJson()
      ..addAll({
        fieldName: await MultipartFile.fromFile(
          client.selectedImage!.path,
          filename: client.selectedImage!.path.split('/').last,
        ),
      }));
    final options = Options(
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );

    return switch (type) {
      ClientEnpointType.createWithImage =>
        _createClient(client, data: formData, options: options),
      ClientEnpointType.updateWithImage =>
        _updateClient(client, data: formData, options: options),
      _ => throw AppFailure(
          'ClientEnpointType must be either createWithImage or updateWithImage',
        ),
    };
  }
}

enum ClientEnpointType {
  create,
  update,
  createWithImage,
  updateWithImage,
}

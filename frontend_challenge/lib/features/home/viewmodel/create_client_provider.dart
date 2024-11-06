import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/models/repositories/client_remote_repository_provider.dart';
import 'package:frontend_challenge/features/home/viewmodel/paginated_clients_rovider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_client_provider.g.dart';

@riverpod
Future<CustomerModel?> createClient(Ref ref, CustomerModel client) async {
  final response = await ref.read(clientRemoteRepositoryProvider).handleClient(
      client,
      type: client.selectedImage == null
          ? ClientEnpointType.create
          : ClientEnpointType.createWithImage);

  if (response.isLeft()) {
    final error = response.getLeft().toNullable();
    throw error!.message;
  }

  final finalClient = response.getRight().toNullable();

  if (finalClient != null) {
    ref.read(paginatedClientsProvider.notifier).addClient(finalClient);
  }

  return client;
}

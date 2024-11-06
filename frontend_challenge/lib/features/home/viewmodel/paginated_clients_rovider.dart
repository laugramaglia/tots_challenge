import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/models/paginated_response.dart';
import 'package:frontend_challenge/features/home/models/repositories/client_remote_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paginated_clients_rovider.g.dart';

@Riverpod(keepAlive: true)
class PaginatedClients extends _$PaginatedClients {
  PaginatedResponse<CustomerModel>? _paginated;

  @override
  Future<PaginatedResponse<CustomerModel>?> build() async {
    // Load the first page when the provider is initialized
    await _loadPage();
    return _paginated;
  }

  // Method to load the next page
  Future<void> nextPage() async {
    // If already loading or there is no next page, return early
    if (state.isLoading || !_hasNextPage) return;

    state = const AsyncValue.loading();

    await _loadPage();
    state = AsyncValue.data(_paginated);
  }

  void addClient(CustomerModel client) {
    state = const AsyncValue.loading();
    if (_paginated != null) {
      _paginated = _paginated!.copyWithAddItems(items: [client]);
    }
    state = AsyncValue.data(_paginated);
  }

  void updateClient(CustomerModel client) {
    state = const AsyncValue.loading();
    if (_paginated != null) {
      final items = _paginated!.items;
      _paginated = _paginated!.copyWithUpdateItem(List<CustomerModel>.from(
          items!.map((i) => i.id == client.id ? client : i)));
    }
    state = AsyncValue.data(_paginated);
  }

  // Method to load a page of data
  Future<void> _loadPage() async {
    final response = await ref
        .read(clientRemoteRepositoryProvider)
        .getClients(page: _nextPage);

    // Handle failure by throwing an error
    if (response.isLeft()) {
      final error = response.getLeft().toNullable();
      throw error!;
    }

    // Parse the response and update _paginated
    final newPage = response.getRight().toNullable();

    if (newPage != null) {
      if (_paginated == null) {
        _paginated = newPage; // Initialize _paginated
      } else {
        final newItems = List<CustomerModel>.from((newPage.items ?? [])
            .where((item) => !_paginated!.items!.contains(item)));
        _paginated = _paginated!.copyWithAddItems(
          items: newItems,
          totalItems: newPage.totalItems,
          totalPages: newPage.totalPages,
          page: newPage.page,
        );
      }
    }
  }

  // Check if there is a next page
  bool get _hasNextPage => !(_paginated?.isLastPage ?? false);

  // Calculate the next page number
  int get _nextPage => (_paginated?.page ?? 0) + 1;
}

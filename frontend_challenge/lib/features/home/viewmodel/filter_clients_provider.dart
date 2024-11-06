import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/viewmodel/paginated_clients_rovider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_clients_provider.g.dart';

@riverpod
class FilterClients extends _$FilterClients {
  List<CustomerModel> _clients = [];
  String _filterQuery = '';
  @override
  List<CustomerModel> build() => _updateClientsPage();

  List<CustomerModel> _updateClientsPage() {
    final response = ref.watch(paginatedClientsProvider).asData?.value?.items;
    if (response != null) {
      _clients = response;
    }
    return _filterClientsByQuerry();
  }

  void filterByQuery([String? query]) {
    if (query != null) {
      _filterQuery = query;
    }
    state = _filterClientsByQuerry();
  }

  List<CustomerModel> _filterClientsByQuerry() {
    return List<CustomerModel>.from(_clients.where(
        (c) => c.fullName.toLowerCase().contains(_filterQuery.toLowerCase())));
  }
}

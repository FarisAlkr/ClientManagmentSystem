import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/client.dart';
import '../../data/clients_repository.dart';

final clientsRepositoryProvider = Provider<ClientsRepository>((ref) {
  return ClientsRepository();
});

final clientsStreamProvider = StreamProvider.family<List<Client>, String>((ref, cityId) {
  final repository = ref.watch(clientsRepositoryProvider);
  ref.keepAlive(); // Keep stream alive to prevent reconnection lag
  return repository.getClientsByCityStream(cityId);
});

final clientSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredClientsProvider = Provider.family<List<Client>, String>((ref, cityId) {
  final clientsAsync = ref.watch(clientsStreamProvider(cityId));
  final searchQuery = ref.watch(clientSearchQueryProvider).toLowerCase();

  return clientsAsync.when(
    data: (clients) {
      if (searchQuery.isEmpty) {
        return clients;
      }
      return clients.where((client) {
        return client.name.toLowerCase().contains(searchQuery) ||
               client.propertyAddress.toLowerCase().contains(searchQuery) ||
               client.idNumber.contains(searchQuery) ||
               client.handlingCommittee.toLowerCase().contains(searchQuery);
      }).toList();
    },
    loading: () => <Client>[], // Return empty list while loading
    error: (_, __) => <Client>[], // Return empty list on error
  );
});

final clientProvider = FutureProvider.family<Client?, String>((ref, clientId) {
  final repository = ref.watch(clientsRepositoryProvider);
  return repository.getClient(clientId);
});
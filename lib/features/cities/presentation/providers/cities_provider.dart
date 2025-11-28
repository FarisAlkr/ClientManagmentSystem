import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/city.dart';
import '../../data/cities_repository.dart';

final citiesRepositoryProvider = Provider<CitiesRepository>((ref) {
  return CitiesRepository();
});

final citiesStreamProvider = StreamProvider<List<City>>((ref) {
  final repository = ref.watch(citiesRepositoryProvider);
  ref.keepAlive();  // Keep the stream alive to prevent reconnection lag
  return repository.getCitiesStream();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredCitiesProvider = Provider<List<City>>((ref) {
  final citiesAsync = ref.watch(citiesStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return citiesAsync.when(
    data: (cities) {
      if (searchQuery.isEmpty) {
        return cities;
      }
      return cities.where((city) {
        return city.name.toLowerCase().contains(searchQuery) ||
               city.description.toLowerCase().contains(searchQuery);
      }).toList();
    },
    loading: () => <City>[], // Return empty list while loading
    error: (_, __) => <City>[], // Return empty list on error
  );
});

final addCityProvider = FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repository = ref.watch(citiesRepositoryProvider);
  return repository.addCity(params['name']!, params['description']!);
});
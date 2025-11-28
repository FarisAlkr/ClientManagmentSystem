import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/committee.dart';
import '../../data/committees_repository.dart';

final committeesRepositoryProvider = Provider<CommitteesRepository>((ref) {
  return CommitteesRepository();
});

final committeesStreamProvider = StreamProvider<List<Committee>>((ref) {
  final repository = ref.watch(committeesRepositoryProvider);
  ref.keepAlive();
  return repository.getCommitteesStream();
});

final searchCommitteeQueryProvider = StateProvider<String>((ref) => '');

final filteredCommitteesProvider = Provider<List<Committee>>((ref) {
  final committeesAsync = ref.watch(committeesStreamProvider);
  final searchQuery = ref.watch(searchCommitteeQueryProvider).toLowerCase();

  return committeesAsync.when(
    data: (committees) {
      if (searchQuery.isEmpty) {
        return committees;
      }
      return committees.where((committee) {
        return committee.name.toLowerCase().contains(searchQuery);
      }).toList();
    },
    loading: () => <Committee>[],
    error: (_, __) => <Committee>[],
  );
});

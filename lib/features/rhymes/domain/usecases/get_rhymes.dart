// lib/features/rhymes/domain/usecases/get_rhymes.dart

import '../entities/rhyme_item.dart';
import '../repositories/rhymes_repository.dart';

class GetRhymes {
  final RhymesRepository repository;

  GetRhymes(this.repository);

  Future<List<RhymeItem>> call() {
    return repository.getRhymes();
  }
}

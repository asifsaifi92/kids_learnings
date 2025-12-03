// lib/features/rhymes/domain/repositories/rhymes_repository.dart

import '../entities/rhyme_item.dart';

abstract class RhymesRepository {
  Future<List<RhymeItem>> getRhymes();
}

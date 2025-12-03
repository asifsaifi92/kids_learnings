// lib/features/rhymes/data/repositories/rhymes_repository_impl.dart

import '../../domain/entities/rhyme_item.dart';
import '../../domain/repositories/rhymes_repository.dart';
import '../datasources/rhymes_local_data_source.dart';

class RhymesRepositoryImpl implements RhymesRepository {
  final RhymesLocalDataSource localDataSource;

  RhymesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RhymeItem>> getRhymes() {
    return localDataSource.getRhymes();
  }
}

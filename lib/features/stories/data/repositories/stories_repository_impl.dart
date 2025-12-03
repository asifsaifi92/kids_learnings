// lib/features/stories/data/repositories/stories_repository_impl.dart

import '../../domain/entities/story_item.dart';
import '../../domain/repositories/stories_repository.dart';
import '../datasources/stories_local_data_source.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesLocalDataSource localDataSource;

  StoriesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<StoryItem>> getStories() {
    return localDataSource.getStories();
  }
}

// lib/features/stories/domain/repositories/stories_repository.dart

import '../entities/story_item.dart';

abstract class StoriesRepository {
  Future<List<StoryItem>> getStories();
}


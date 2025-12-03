// lib/features/stories/domain/usecases/get_stories.dart

import '../entities/story_item.dart';
import '../repositories/stories_repository.dart';

class GetStories {
  final StoriesRepository repository;
  GetStories(this.repository);

  Future<List<StoryItem>> call() async => await repository.getStories();
}


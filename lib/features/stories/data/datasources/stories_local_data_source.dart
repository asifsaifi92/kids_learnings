// lib/features/stories/data/datasources/stories_local_data_source.dart

import '../../domain/entities/story_item.dart';

abstract class StoriesLocalDataSource {
  Future<List<StoryItem>> getStories();
}

class StoriesLocalDataSourceImpl implements StoriesLocalDataSource {
  @override
  Future<List<StoryItem>> getStories() async {
    await Future.delayed(const Duration(milliseconds: 60));
    return [
      StoryItem(
        id: 1,
        title: 'The Brave Little Rabbit',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Once upon a time there was a brave little rabbit.', imageAsset: 'assets/images/stories/rabbit1.png'),
          StoryPageItem(pageNumber: 2, text: 'He helped his friends in the forest.', imageAsset: 'assets/images/stories/rabbit2.png'),
          StoryPageItem(pageNumber: 3, text: 'They all lived happily ever after.', imageAsset: 'assets/images/stories/rabbit3.png'),
        ],
      ),
      StoryItem(
        id: 2,
        title: 'Milo and the Moon',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Milo looked up at the bright moon and waved.', imageAsset: 'assets/images/stories/moon1.png'),
          StoryPageItem(pageNumber: 2, text: 'He wished to visit the moon one day.', imageAsset: 'assets/images/stories/moon2.png'),
          StoryPageItem(pageNumber: 3, text: 'Milo learned about stars and planets.', imageAsset: 'assets/images/stories/moon3.png'),
          StoryPageItem(pageNumber: 4, text: 'He dreamed big and smiled.', imageAsset: 'assets/images/stories/moon4.png'),
        ],
      ),
    ];
  }
}

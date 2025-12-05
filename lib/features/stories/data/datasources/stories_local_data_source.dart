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
      StoryItem(
        id: 3,
        title: 'Luna the Little Cloud',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Luna floated high and watched the world below.'),
          StoryPageItem(pageNumber: 2, text: 'She learned to make rain to help the flowers.'),
        ],
      ),
      StoryItem(
        id: 4,
        title: 'Timmy and the Tiny Seed',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Timmy planted a tiny seed in his backyard.'),
          StoryPageItem(pageNumber: 2, text: 'With water and sunshine it grew into a tall tree.'),
        ],
      ),
      StoryItem(
        id: 5,
        title: 'The Little Boat',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'A little boat sailed across the calm lake.'),
          StoryPageItem(pageNumber: 2, text: 'The boat met friendly fish and a playful breeze.'),
        ],
      ),
      StoryItem(
        id: 6,
        title: 'Penny and the Paints',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Penny mixed colors to paint the rainbow.'),
          StoryPageItem(pageNumber: 2, text: 'Her painting brightened the whole town.'),
        ],
      ),
      StoryItem(
        id: 7,
        title: 'Sammy the Snail',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Sammy moved slowly but saw many wonders.'),
          StoryPageItem(pageNumber: 2, text: 'He made a new friend under a leaf.'),
        ],
      ),
      StoryItem(
        id: 8,
        title: 'The Singing Tree',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'There was a tree that sang in the morning.'),
          StoryPageItem(pageNumber: 2, text: 'Children gathered to listen and clap.'),
        ],
      ),
      StoryItem(
        id: 9,
        title: 'Nora and the Night Lamp',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'Nora kept a little lamp to guide her dreams.'),
          StoryPageItem(pageNumber: 2, text: 'The lamp glowed warm and kept the dark away.'),
        ],
      ),
      StoryItem(
        id: 10,
        title: 'The Curious Kitten',
        pages: [
          StoryPageItem(pageNumber: 1, text: 'A curious kitten climbed the tallest chair.'),
          StoryPageItem(pageNumber: 2, text: 'It discovered a ball of yarn and played all day.'),
        ],
      ),
    ];
  }
}

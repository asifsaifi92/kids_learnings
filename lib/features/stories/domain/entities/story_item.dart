// lib/features/stories/domain/entities/story_item.dart

class StoryPageItem {
  final int pageNumber;
  final String text;
  final String? imageAsset;

  const StoryPageItem({required this.pageNumber, required this.text, this.imageAsset});
}

class StoryItem {
  final int id;
  final String title;
  final List<StoryPageItem> pages;

  const StoryItem({required this.id, required this.title, required this.pages});
}


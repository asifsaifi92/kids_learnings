// lib/features/rhymes/domain/entities/rhyme_item.dart

class RhymeItem {
  final String id;
  final String title;
  final String lyrics;
  final String ttsText;

  RhymeItem({
    required this.id,
    required this.title,
    required this.lyrics,
    required this.ttsText,
  });
}

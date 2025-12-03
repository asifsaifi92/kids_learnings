// lib/features/rhymes/domain/entities/rhyme_item.dart

class RhymeItem {
  final String id;
  final String title;
  final String durationText;
  final String assetPath;
  final String ttsIntro;

  RhymeItem({
    required this.id,
    required this.title,
    required this.durationText,
    required this.assetPath,
    required this.ttsIntro,
  });
}

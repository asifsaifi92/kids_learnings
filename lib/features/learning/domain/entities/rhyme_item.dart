import 'package:flutter/foundation.dart';

@immutable
class RhymeItem {
  final String id;
  final String title;
  final String durationText;
  final String assetPath;
  final String ttsIntro;

  const RhymeItem({
    required this.id,
    required this.title,
    required this.durationText,
    required this.assetPath,
    required this.ttsIntro,
  });
}

// lib/features/learning/domain/entities/alphabet_item.dart
import 'package:flutter/foundation.dart';

@immutable
class AlphabetItem {
  final String letter;
  final String word;
  final String ttsText;

  const AlphabetItem({
    required this.letter,
    required this.word,
    required this.ttsText,
  });
}


// lib/features/learning/data/models/alphabet_model.dart
import '../../domain/entities/alphabet_item.dart';

class AlphabetModel extends AlphabetItem {
  const AlphabetModel({
    required super.letter,
    required super.word,
    required super.ttsText,
  });
}

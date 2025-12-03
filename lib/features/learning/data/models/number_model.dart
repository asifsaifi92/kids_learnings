// lib/features/learning/data/models/number_model.dart
import '../../domain/entities/number_item.dart';

class NumberModel extends NumberItem {
  const NumberModel({
    required super.value,
    required super.label,
    required super.ttsText,
  });
}

// lib/features/learning/domain/entities/number_item.dart
import 'package:flutter/foundation.dart';

@immutable
class NumberItem {
  final int value;
  final String label;
  final String ttsText;

  const NumberItem({
    required this.value,
    required this.label,
    required this.ttsText,
  });
}

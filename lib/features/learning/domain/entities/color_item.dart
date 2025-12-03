
import 'package:flutter/material.dart';

class ColorItem {
  final int id;
  final String name;
  final String displayText;
  final Color colorValue;
  final String ttsText;

  const ColorItem({
    required this.id,
    required this.name,
    required this.displayText,
    required this.colorValue,
    required this.ttsText,
  });
}

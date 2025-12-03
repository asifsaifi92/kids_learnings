import 'package:flutter/material.dart';
import '''../../domain/entities/color_item.dart''';

class ColorModel extends ColorItem {
  const ColorModel({
    required int id,
    required String name,
    required String displayText,
    required Color colorValue,
    required String ttsText,
  }) : super(
          id: id,
          name: name,
          displayText: displayText,
          colorValue: colorValue,
          ttsText: ttsText,
        );
}

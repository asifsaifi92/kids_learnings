// lib/features/shapes/domain/entities/shape_item.dart

import 'package:flutter/material.dart';

class ShapeItem {
  final int id;
  final String name;
  final String displayText;
  final String ttsText;
  final Widget shapeWidget;

  ShapeItem({
    required this.id,
    required this.name,
    required this.displayText,
    required this.ttsText,
    required this.shapeWidget,
  });
}

import 'package:flutter/material.dart';

class ShapeItem {
  final int id;
  final String name;
  final String displayText;
  final String ttsText;
  // A widget builder can be used to render the shape
  final Widget Function(double size) shapeBuilder;

  const ShapeItem({
    required this.id,
    required this.name,
    required this.displayText,
    required this.ttsText,
    required this.shapeBuilder,
  });
}

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';

class ShapeModel extends ShapeItem {
  const ShapeModel({
    required int id,
    required String name,
    required String displayText,
    required String ttsText,
    required Widget Function(double size) shapeBuilder,
  }) : super(
          id: id,
          name: name,
          displayText: displayText,
          ttsText: ttsText,
          shapeBuilder: shapeBuilder,
        );
}

// lib/features/shapes/data/models/shape_model.dart

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';

class ShapeModel extends ShapeItem {
  ShapeModel({
    required int id,
    required String name,
    required String displayText,
    required String ttsText,
    required Widget shapeWidget,
  }) : super(
          id: id,
          name: name,
          displayText: displayText,
          ttsText: ttsText,
          shapeWidget: shapeWidget,
        );
}

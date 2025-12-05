// lib/features/shapes/presentation/widgets/shape_tile.dart

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';

class ShapeTile extends StatelessWidget {
  final ShapeItem shapeItem;
  final bool isLearned;

  const ShapeTile({
    super.key,
    required this.shapeItem,
    this.isLearned = false, // Default to not learned
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLearned
              ? [Colors.green.shade100, Colors.lightGreen.shade200] // Learned state color
              : [Colors.white, Colors.grey.shade200], // Default state color
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 15,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: shapeItem.shapeWidget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              shapeItem.displayText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

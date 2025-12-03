// lib/features/learning/presentation/widgets/background_bubble.dart
import 'package:flutter/material.dart';

class BackgroundBubble extends StatelessWidget {
  final double size;
  final Color color;

  const BackgroundBubble({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// lib/features/colors/presentation/widgets/color_bubble.dart

import 'package:flutter/material.dart';

class ColorBubble extends StatelessWidget {
  final String label;
  final String colorHex;
  final bool isLearned;

  const ColorBubble({
    super.key,
    required this.label,
    required this.colorHex,
    this.isLearned = false, // Default to not learned
  });

  Color _parseHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(colorHex);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color.withOpacity(0.95), color.withOpacity(0.7)], center: Alignment(-0.2, -0.2), focal: Alignment(0.1, 0.1)),
        boxShadow: [BoxShadow(color: Colors.black26, offset: const Offset(0, 12), blurRadius: 18)],
      ),
      child: Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Center(
            child: isLearned
                ? const Icon(Icons.check_circle, color: Colors.white, size: 36) // Show checkmark if learned
                : Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

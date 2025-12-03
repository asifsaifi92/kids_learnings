// lib/features/shapes/presentation/widgets/shape_card.dart

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';

enum ShapeType { circle, square, triangle, rectangle, star, heart, oval, diamond }

class ShapeCard extends StatelessWidget {
  final ShapeItem item;
  final ShapeType type; // Added to make the switch work

  const ShapeCard({super.key, required this.item, required this.type});

  Widget _shapeWidget() {
    switch (type) {
      case ShapeType.circle:
        return Container(width: 64, height: 64, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
      case ShapeType.square:
        return Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)));
      case ShapeType.triangle:
        return CustomPaint(size: const Size(64, 64), painter: _TrianglePainter());
      case ShapeType.rectangle:
        return Container(width: 80, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)));
      case ShapeType.star:
        return const Icon(Icons.star, size: 48, color: Colors.white);
      case ShapeType.heart:
        return const Icon(Icons.favorite, size: 48, color: Colors.white);
      case ShapeType.oval:
        return Container(width: 80, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)));
      case ShapeType.diamond:
         return CustomPaint(size: const Size(64, 64), painter: _DiamondPainter());
      default:
        return const SizedBox.shrink(); // Always return a widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFC94F), Color(0xFFFFA726)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 18)],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.2)], center: const Alignment(-0.2, -0.2)),
            ),
            child: Center(child: _shapeWidget()),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

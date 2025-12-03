// lib/features/shapes/data/datasources/shapes_local_data_source.dart

import 'dart:math';

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';

abstract class ShapesLocalDataSource {
  Future<List<ShapeItem>> getShapeItems();
}

class ShapesLocalDataSourceImpl implements ShapesLocalDataSource {
  @override
  Future<List<ShapeItem>> getShapeItems() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      ShapeItem(
        id: 1,
        name: 'Circle',
        displayText: 'Circle',
        ttsText: 'This is a circle',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: CirclePainter()),
        ),
      ),
      ShapeItem(
        id: 2,
        name: 'Square',
        displayText: 'Square',
        ttsText: 'This is a square',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: SquarePainter()),
        ),
      ),
      ShapeItem(
        id: 3,
        name: 'Triangle',
        displayText: 'Triangle',
        ttsText: 'This is a triangle',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: TrianglePainter()),
        ),
      ),
      ShapeItem(
        id: 4,
        name: 'Rectangle',
        displayText: 'Rectangle',
        ttsText: 'This is a rectangle',
        shapeWidget: SizedBox(
          width: 150,
          height: 100,
          child: CustomPaint(painter: RectanglePainter()),
        ),
      ),
      ShapeItem(
        id: 5,
        name: 'Star',
        displayText: 'Star',
        ttsText: 'This is a star',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: StarPainter()),
        ),
      ),
      ShapeItem(
        id: 6,
        name: 'Heart',
        displayText: 'Heart',
        ttsText: 'This is a heart',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: HeartPainter()),
        ),
      ),
      ShapeItem(
        id: 7,
        name: 'Oval',
        displayText: 'Oval',
        ttsText: 'This is an oval',
        shapeWidget: SizedBox(
          width: 150,
          height: 100,
          child: CustomPaint(painter: OvalPainter()),
        ),
      ),
      ShapeItem(
        id: 8,
        name: 'Diamond',
        displayText: 'Diamond',
        ttsText: 'This is a diamond',
        shapeWidget: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: DiamondPainter()),
        ),
      ),
    ];
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.orange;
    canvas.drawRect(Rect.fromLTWH(0, size.height / 4, size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.yellow;
    var path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;
    double innerRadius = radius / 2.5;
    int points = 5;
    double angle = -pi / 2;
    double angleIncrement = pi / points;

    path.moveTo(centerX + radius * cos(angle), centerY + radius * sin(angle));

    for (int i = 0; i < 2 * points; i++) {
      angle += angleIncrement;
      double r = (i % 2 == 0) ? innerRadius : radius;
      path.lineTo(centerX + r * cos(angle), centerY + r * sin(angle));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.35);
    path.cubicTo(size.width * 0.2, size.height * 0.1, -size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.9);
    path.moveTo(size.width * 0.5, size.height * 0.35);
    path.cubicTo(size.width * 0.8, size.height * 0.1, size.width * 1.25, size.height * 0.6, size.width * 0.5, size.height * 0.9);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple;
    canvas.drawOval(Rect.fromLTWH(0, size.height/4, size.width, size.height/2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.cyan;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

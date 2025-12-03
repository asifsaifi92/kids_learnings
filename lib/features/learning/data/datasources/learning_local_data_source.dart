import 'package:flutter/material.dart';
import 'dart:math';
import '../models/alphabet_model.dart';
import '../models/number_model.dart';
import '../models/color_model.dart';
import '../models/shape_model.dart';

abstract class LearningLocalDataSource {
  List<AlphabetModel> getAlphabetItems();
  List<NumberModel> getNumberItems();
  Future<List<ColorModel>> getColorItems();
  Future<List<ShapeModel>> getShapeItems();
}

class LearningLocalDataSourceImpl implements LearningLocalDataSource {
  @override
  List<AlphabetModel> getAlphabetItems() {
    const words = ['Apple', 'Ball', 'Cat', 'Dog', 'Elephant', 'Fish', 'Goat', 'Hat', 'Ice Cream', 'Jug', 'Kite', 'Lion', 'Monkey', 'Nest', 'Orange', 'Parrot', 'Queen', 'Rabbit', 'Sun', 'Tiger', 'Umbrella', 'Van', 'Watch', 'Xylophone', 'Yak', 'Zebra'];
    return List.generate(26, (index) {
      final letter = String.fromCharCode(65 + index);
      final word = words[index];
      return AlphabetModel(
        letter: letter,
        word: word,
        ttsText: '$letter for $word',
      );
    });
  }

  @override
  List<NumberModel> getNumberItems() {
    const labels = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty'];
    return List.generate(20, (index) {
      final value = index + 1;
      final label = labels[index];
      return NumberModel(
        value: value,
        label: label,
        ttsText: label,
      );
    });
  }

  @override
  Future<List<ColorModel>> getColorItems() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    return const [
      ColorModel(id: 1, name: 'Red', displayText: 'Red', colorValue: Colors.red, ttsText: 'Red'),
      ColorModel(id: 2, name: 'Blue', displayText: 'Blue', colorValue: Colors.blue, ttsText: 'Blue'),
      ColorModel(id: 3, name: 'Green', displayText: 'Green', colorValue: Colors.green, ttsText: 'Green'),
      ColorModel(id: 4, name: 'Yellow', displayText: 'Yellow', colorValue: Colors.yellow, ttsText: 'Yellow'),
      ColorModel(id: 5, name: 'Orange', displayText: 'Orange', colorValue: Colors.orange, ttsText: 'Orange'),
      ColorModel(id: 6, name: 'Purple', displayText: 'Purple', colorValue: Colors.purple, ttsText: 'Purple'),
      ColorModel(id: 7, name: 'Pink', displayText: 'Pink', colorValue: Colors.pink, ttsText: 'Pink'),
      ColorModel(id: 8, name: 'Brown', displayText: 'Brown', colorValue: Colors.brown, ttsText: 'Brown'),
      ColorModel(id: 9, name: 'Black', displayText: 'Black', colorValue: Colors.black, ttsText: 'Black'),
      ColorModel(id: 10, name: 'White', displayText: 'White', colorValue: Colors.white, ttsText: 'White'),
    ];
  }

  @override
  Future<List<ShapeModel>> getShapeItems() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    return [
      ShapeModel(id: 1, name: 'Circle', displayText: 'Circle', ttsText: 'This is a circle', shapeBuilder: (size) => Container(width: size, height: size, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
      ShapeModel(id: 2, name: 'Square', displayText: 'Square', ttsText: 'This is a square', shapeBuilder: (size) => Container(width: size, height: size, color: Colors.blue)),
      ShapeModel(id: 3, name: 'Triangle', displayText: 'Triangle', ttsText: 'This is a triangle', shapeBuilder: (size) => CustomPaint(size: Size(size, size), painter: TrianglePainter())),
      ShapeModel(id: 4, name: 'Rectangle', displayText: 'Rectangle', ttsText: 'This is a rectangle', shapeBuilder: (size) => Container(width: size, height: size / 2, color: Colors.green)),
      ShapeModel(id: 5, name: 'Star', displayText: 'Star', ttsText: 'This is a star', shapeBuilder: (size) => CustomPaint(size: Size(size, size), painter: StarPainter())),
      ShapeModel(id: 6, name: 'Heart', displayText: 'Heart', ttsText: 'This is a heart', shapeBuilder: (size) => CustomPaint(size: Size(size, size), painter: HeartPainter())),
      ShapeModel(id: 7, name: 'Oval', displayText: 'Oval', ttsText: 'This is an oval', shapeBuilder: (size) => Container(width: size, height: size / 1.5, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(size / 2)))),
      ShapeModel(id: 8, name: 'Diamond', displayText: 'Diamond', ttsText: 'This is a diamond', shapeBuilder: (size) => CustomPaint(size: Size(size, size), painter: DiamondPainter())),
    ];
  }
}

// Custom Painters for Shapes

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple;
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

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow;
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;
    const points = 5;
    const angle = (2 * 3.1415926535) / (points * 2);
    
    path.moveTo(centerX + radius * cos(0), centerY + radius * sin(0));
    for (int i = 1; i <= points * 2; i++) {
      final r = i.isEven ? radius : radius / 2;
      path.lineTo(centerX + r * cos(angle * i), centerY + r * sin(angle * i));
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
    final paint = Paint()..color = Colors.pink;
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

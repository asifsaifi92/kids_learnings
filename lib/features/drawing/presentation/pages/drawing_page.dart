
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// A simple data class to hold the path and the paint properties for each stroke.
class DrawingPath {
  final Path path;
  final Paint paint;
  DrawingPath({required this.path, required this.paint});
}

class DrawingPage extends StatefulWidget {
  static const routeName = '/drawing';
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final _paths = <DrawingPath>[]; // List to store all drawn paths
  final _undoHistory = <DrawingPath>[]; // List to store undone paths for redo
  DrawingPath? _currentPath; // The path currently being drawn

  Color _currentColor = Colors.red;
  double _currentStrokeWidth = 5.0;

  // This will be our background image for coloring book mode
  ui.Image? _backgroundImage;

  // --- Core Drawing Logic ---

  void _onPanStart(DragStartDetails details) {
    _undoHistory.clear(); // Clear redo history once a new drawing starts
    final paint = _createPaint();
    final path = Path();
    path.moveTo(details.localPosition.dx, details.localPosition.dy);
    setState(() {
      _currentPath = DrawingPath(path: path, paint: paint);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPath?.path.lineTo(details.localPosition.dx, details.localPosition.dy);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPath != null) {
      setState(() {
        _paths.add(_currentPath!);
        _currentPath = null;
      });
    }
  }

  Paint _createPaint() {
    return Paint()
      ..color = _currentColor
      ..strokeWidth = _currentStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  // --- Toolbar Actions ---

  void _undo() {
    if (_paths.isNotEmpty) {
      setState(() {
        _undoHistory.add(_paths.removeLast());
      });
    }
  }

  void _redo() {
    if (_undoHistory.isNotEmpty) {
      setState(() {
        _paths.add(_undoHistory.removeLast());
      });
    }
  }

  void _clear() {
    setState(() {
      _paths.clear();
      _undoHistory.clear();
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) {
              setState(() {
                _currentColor = color;
              });
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveDrawing() async {
    final status = await Gal.requestAccess();
    if (!status) {
      _showErrorSnackbar('Storage permission is required to save drawings.');
      return;
    }

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = DrawingPainter(paths: _paths, backgroundImage: _backgroundImage);
      final size = context.size!;
      painter.paint(canvas, size);
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        await Gal.putImageBytes(byteData.buffer.asUint8List(), album: 'Kids Drawing');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drawing saved to gallery!')),
        );
        // Update challenge progress
        context.read<DailyChallengeProvider>().updateProgress(ChallengeType.DrawSomething);
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while saving.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawing Board')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(paths: _paths, currentPath: _currentPath, backgroundImage: _backgroundImage),
                size: Size.infinite,
              ),
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolButton(Icons.undo, 'Undo', _undo),
          _buildToolButton(Icons.redo, 'Redo', _redo),
          IconButton(
            icon: Icon(Icons.color_lens, color: _currentColor, size: 32),
            tooltip: 'Color',
            onPressed: _showColorPicker,
          ),
          _buildToolButton(Icons.brush, 'Size', () { /* TODO: Show size slider */ }),
          _buildToolButton(Icons.clear, 'Clear', _clear),
          _buildToolButton(Icons.save_alt, 'Save', _saveDrawing),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 32),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final DrawingPath? currentPath;
  final ui.Image? backgroundImage;

  DrawingPainter({required this.paths, this.currentPath, this.backgroundImage});

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundImage != null) {
      final paint = Paint();
      final outputRect = Rect.fromLTWH(0, 0, size.width, size.height);
      final inputRect = Rect.fromLTWH(0, 0, backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
      canvas.drawImageRect(backgroundImage!, inputRect, outputRect, paint);
    } else {
      canvas.drawColor(Colors.white, BlendMode.srcOver);
    }

    for (var drawingPath in paths) {
      canvas.drawPath(drawingPath.path, drawingPath.paint);
    }

    if (currentPath != null) {
      canvas.drawPath(currentPath!.path, currentPath!.paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return paths != oldDelegate.paths ||
        currentPath != oldDelegate.currentPath ||
        backgroundImage != oldDelegate.backgroundImage;
  }
}

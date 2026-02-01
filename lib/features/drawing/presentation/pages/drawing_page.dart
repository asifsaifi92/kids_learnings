
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/utils/flood_fill_utils.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:provider/provider.dart';

enum DrawingMode { pencil, fill }

class DrawingPage extends StatefulWidget {
  static const routeName = '/drawing';
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  // Raster Canvas State
  ui.Image? _canvasImage; 
  final List<ui.Image> _undoStack = []; 
  
  // Current Stroke State
  DrawingPath? _currentPath;
  
  // Audio State for Scribbling
  final AudioPlayer _scribblePlayer = AudioPlayer();
  
  // Settings
  DrawingMode _mode = DrawingMode.pencil;
  Color _currentColor = Colors.red;
  double _currentStrokeWidth = 5.0;
  bool _isProcessing = false; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCanvas(context.size ?? const Size(800, 1200));
    });
    // Preload sound
    _scribblePlayer.setReleaseMode(ReleaseMode.loop);
    _scribblePlayer.setSource(AssetSource('sounds/ui/click.wav'));
    _scribblePlayer.setVolume(0.5);
  }
  
  @override
  void dispose() {
    _scribblePlayer.dispose();
    super.dispose();
  }

  Future<void> _initCanvas(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawColor(Colors.white, BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    setState(() {
      _canvasImage = image;
    });
  }

  // --- Interaction Handlers ---

  void _onPanStart(DragStartDetails details) {
    if (_mode == DrawingMode.pencil) {
      // Start Sound
      _scribblePlayer.resume();
      
      final paint = _createPaint();
      final path = Path();
      path.moveTo(details.localPosition.dx, details.localPosition.dy);
      setState(() {
        _currentPath = DrawingPath(path: path, paint: paint);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_mode == DrawingMode.pencil) {
      setState(() {
        _currentPath?.path.lineTo(details.localPosition.dx, details.localPosition.dy);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) async {
    // Stop Sound
    _scribblePlayer.pause();
    
    if (_mode == DrawingMode.pencil && _currentPath != null) {
      await _bakeCurrentPathToImage();
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (_mode == DrawingMode.fill) {
      SoundManager().playPop(); // Pop sound for fill
      await _performFloodFill(details.localPosition);
    } else if (_mode == DrawingMode.pencil) {
      _onPanStart(DragStartDetails(localPosition: details.localPosition));
      _onPanEnd(DragEndDetails());
    }
  }

  // --- Core Logic ---

  Future<void> _bakeCurrentPathToImage() async {
    if (_canvasImage == null || _currentPath == null) return;

    _saveStateToUndo();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.drawImage(_canvasImage!, Offset.zero, Paint());
    canvas.drawPath(_currentPath!.path, _currentPath!.paint);
    
    final picture = recorder.endRecording();
    final newImage = await picture.toImage(_canvasImage!.width, _canvasImage!.height);

    setState(() {
      _canvasImage = newImage;
      _currentPath = null;
    });
  }

  Future<void> _performFloodFill(Offset position) async {
    if (_canvasImage == null || _isProcessing) return;

    setState(() => _isProcessing = true);
    
    try {
      _saveStateToUndo();
      final img.Image sourceImage = await FloodFillUtils.convertUiImageToImgImage(_canvasImage!);
      final int x = position.dx.toInt();
      final int y = position.dy.toInt();
      final img.Image filledImage = FloodFillUtils.floodFill(sourceImage, x, y, _currentColor);
      final ui.Image resultImage = await FloodFillUtils.convertImgImageToUiImage(filledImage);

      setState(() {
        _canvasImage = resultImage;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Flood fill error: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _saveStateToUndo() {
    if (_canvasImage != null) {
      if (_undoStack.length >= 10) {
        _undoStack.removeAt(0); 
      }
      _undoStack.add(_canvasImage!); 
    }
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        _canvasImage = _undoStack.removeLast();
      });
    }
  }

  void _clear() {
    if (_canvasImage == null) return;
    _saveStateToUndo();
    _initCanvas(Size(_canvasImage!.width.toDouble(), _canvasImage!.height.toDouble()));
  }

  Paint _createPaint() {
    return Paint()
      ..color = _currentColor
      ..strokeWidth = _currentStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  // --- Toolbar & UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magic Drawing Board')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (_canvasImage == null) {
                   return const Center(child: CircularProgressIndicator());
                }
                
                return GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  onTapUp: _onTapUp,
                  child: CustomPaint(
                    painter: RasterDrawingPainter(
                      image: _canvasImage,
                      currentPath: _currentPath,
                    ),
                    size: Size.infinite,
                  ),
                );
              },
            ),
          ),
          if (_isProcessing) const LinearProgressIndicator(),
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
          _buildToolButton(
            icon: Icons.edit, 
            tooltip: 'Pencil', 
            isSelected: _mode == DrawingMode.pencil,
            onPressed: () => setState(() => _mode = DrawingMode.pencil)
          ),
          _buildToolButton(
            icon: Icons.format_color_fill, 
            tooltip: 'Magic Fill', 
            isSelected: _mode == DrawingMode.fill,
            onPressed: () => setState(() => _mode = DrawingMode.fill)
          ),
          IconButton(
            icon: Icon(Icons.color_lens, color: _currentColor, size: 32),
            tooltip: 'Color',
            onPressed: _showColorPicker,
          ),
          _buildToolButton(
            icon: Icons.undo, 
            tooltip: 'Undo', 
            onPressed: _undo
          ),
          _buildToolButton(
            icon: Icons.delete, 
            tooltip: 'Clear', 
            onPressed: _clear
          ),
          IconButton(
            icon: const Icon(Icons.save_alt, size: 32),
            tooltip: 'Save',
            onPressed: _saveDrawing,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon, 
    required String tooltip, 
    required VoidCallback onPressed,
    bool isSelected = false,
  }) {
    return Container(
      decoration: isSelected ? BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ) : null,
      child: IconButton(
        icon: Icon(icon, size: 32, color: isSelected ? Colors.blue : Colors.black87),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
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
    if (_canvasImage == null) return;
    
    final status = await Gal.requestAccess();
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission is required.')));
      return;
    }

    try {
      final byteData = await _canvasImage!.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        await Gal.putImageBytes(byteData.buffer.asUint8List(), album: 'Kids Drawing');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drawing saved to gallery!')),
        );
        context.read<AchievementsProvider>().incrementProgress('artist');
        context.read<DailyChallengeProvider>().updateProgress(ChallengeType.DrawSomething);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred while saving.')));
    }
  }
}

class RasterDrawingPainter extends CustomPainter {
  final ui.Image? image;
  final DrawingPath? currentPath;

  RasterDrawingPainter({this.image, this.currentPath});

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(image!, Offset.zero, Paint());
    }
    
    if (currentPath != null) {
      canvas.drawPath(currentPath!.path, currentPath!.paint);
    }
  }

  @override
  bool shouldRepaint(covariant RasterDrawingPainter oldDelegate) {
    return image != oldDelegate.image || currentPath != oldDelegate.currentPath;
  }
}

class DrawingPath {
  final Path path;
  final Paint paint;
  DrawingPath({required this.path, required this.paint});
}

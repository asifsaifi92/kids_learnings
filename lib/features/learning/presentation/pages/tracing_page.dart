
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/reward_popup.dart';
import 'package:provider/provider.dart';

class TracingPage extends StatefulWidget {
  final String character;
  
  const TracingPage({super.key, required this.character});

  @override
  State<TracingPage> createState() => _TracingPageState();
}

class _TracingPageState extends State<TracingPage> {
  // Drawing State (List of Strokes, where each stroke is a list of points)
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;
  
  final TextToSpeechService _tts = TextToSpeechService();
  Timer? _inactivityTimer;
  
  // Validation State
  ByteData? _targetBitmap;
  int _imageWidth = 0;
  List<int> _zonePixelCounts = []; 
  int _zones = 1;
  int _zoneWidth = 0;

  final Set<int> _coveredPixels = {}; 
  int _errorPoints = 0;
  int _totalPoints = 0;
  
  bool _isProcessing = true;
  bool _isCompleted = false;
  Size? _canvasSize;

  @override
  void initState() {
    super.initState();
    _tts.init();
    Future.delayed(const Duration(milliseconds: 500), () {
      _tts.speak("Trace the ${int.tryParse(widget.character) != null ? 'number' : 'letter'} ${widget.character}!");
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  Future<void> _initTargetBitmap(Size size) async {
    if (_canvasSize == size) return; 
    _canvasSize = size;
    
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawColor(Colors.transparent, BlendMode.src);

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.character,
        style: TextStyle(
          fontSize: size.width * 0.7, 
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: Colors.black, 
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    
    if (byteData == null) return;

    final int width = size.width.toInt();
    _zones = widget.character.length;
    _zoneWidth = width ~/ _zones;
    _zonePixelCounts = List.filled(_zones, 0);

    for (int i = 3; i < byteData.lengthInBytes; i += 4) {
      if (byteData.getUint8(i) > 50) { 
        final int pixelIndex = (i - 3) ~/ 4;
        final int x = pixelIndex % width;
        final int zoneIndex = (x / _zoneWidth).floor().clamp(0, _zones - 1);
        _zonePixelCounts[zoneIndex]++;
      }
    }

    if (mounted) {
      setState(() {
        _targetBitmap = byteData;
        _imageWidth = width;
        _isProcessing = false;
        _coveredPixels.clear();
        _strokes.clear();
        _errorPoints = 0;
        _totalPoints = 0;
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    _inactivityTimer?.cancel();
    if (_isCompleted || _isProcessing) return;
    setState(() {
      _currentStroke = [details.localPosition];
      _strokes.add(_currentStroke!);
    });
    _validatePoint(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isCompleted || _isProcessing) return;
    setState(() {
      _currentStroke?.add(details.localPosition);
    });
    _validatePoint(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isCompleted || _isProcessing) return;
    _inactivityTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) _checkCompletion();
    });
  }

  void _validatePoint(Offset p) {
    if (_targetBitmap == null || _canvasSize == null) return;
    
    bool hitFound = false;
    const int radius = 20; 
    final int startX = (p.dx - radius).toInt();
    final int endX = (p.dx + radius).toInt();
    final int startY = (p.dy - radius).toInt();
    final int endY = (p.dy + radius).toInt();

    final int maxY = (_targetBitmap!.lengthInBytes / 4 / _imageWidth).floor();

    for (int y = startY; y <= endY; y += 2) { 
      if (y < 0 || y >= maxY) continue;
      for (int x = startX; x <= endX; x += 2) {
        if (x < 0 || x >= _imageWidth) continue;

        final int index = (y * _imageWidth + x) * 4;
        if (index + 3 >= _targetBitmap!.lengthInBytes) continue;

        if (_targetBitmap!.getUint8(index + 3) > 50) {
          hitFound = true;
          _coveredPixels.add(index);
        }
      }
    }

    _totalPoints++;
    if (!hitFound) {
      _errorPoints++;
    }
  }

  void _checkCompletion() {
    if (_targetBitmap == null) return;

    bool allZonesPassed = true;
    final List<int> zoneCoveredCounts = List.filled(_zones, 0);

    for (final pixelIndex in _coveredPixels) {
      final int pixelIdx = pixelIndex ~/ 4;
      final int x = pixelIdx % _imageWidth;
      final int zoneIndex = (x / _zoneWidth).floor().clamp(0, _zones - 1);
      zoneCoveredCounts[zoneIndex]++;
    }

    for (int i = 0; i < _zones; i++) {
      final int totalPixelsInZone = _zonePixelCounts[i];
      final int coveredPixelsInZone = zoneCoveredCounts[i];
      
      if (totalPixelsInZone > 0) { 
        final double zoneRatio = coveredPixelsInZone / totalPixelsInZone;
        if (zoneRatio < 0.30) {
          allZonesPassed = false;
        }
      }
    }

    final double accuracy = 1.0 - (_errorPoints / (_totalPoints == 0 ? 1 : _totalPoints));
    final bool mostlyInside = accuracy > 0.50; 
    final bool longEnough = _totalPoints > 40; 

    if (longEnough && mostlyInside && allZonesPassed) {
      setState(() => _isCompleted = true);
      _handleSuccess();
    } else {
      if (!allZonesPassed) {
         _tts.speak("Trace ALL the parts!");
      } else if (!mostlyInside) {
        _tts.speak("Oops! Stay on the lines.");
      }
      setState(() {
        _strokes.clear();
        _coveredPixels.clear();
        _errorPoints = 0;
        _totalPoints = 0;
      });
    }
  }

  void _handleSuccess() {
    SoundManager().playSuccess();
    _tts.speak("Excellent! You wrote ${widget.character}!");
    
    // Achievement: Math Whiz
    if (int.tryParse(widget.character) != null) {
      context.read<AchievementsProvider>().incrementProgress('math_whiz');
    }

    Provider.of<RewardsProvider>(context, listen: false).awardStar();
    showDialog(context: context, builder: (_) => const RewardPopup())
        .then((_) { if(mounted) Navigator.pop(context); });
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _coveredPixels.clear();
      _errorPoints = 0;
      _totalPoints = 0;
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace: ${widget.character}'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _clear)
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_targetBitmap == null && constraints.biggest.shortestSide > 0) {
            _initTargetBitmap(constraints.biggest);
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: LetterGuidePainter(
                  text: widget.character,
                  color: Colors.grey.shade300,
                ),
              ),
              CustomPaint(
                size: Size.infinite,
                painter: LetterGuidePainter(
                  text: widget.character,
                  color: Colors.grey.shade400,
                  isStroke: true,
                ),
              ),
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: TracingPainter(strokes: _strokes),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TracingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  TracingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.8)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 35.0 
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant TracingPainter oldDelegate) => true;
}

class LetterGuidePainter extends CustomPainter {
  final String text;
  final Color color;
  final bool isStroke;

  LetterGuidePainter({required this.text, required this.color, this.isStroke = false});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size.width * 0.7, 
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          foreground: isStroke 
              ? (Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = color)
              : (Paint()..color = color),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }
  @override
  bool shouldRepaint(covariant LetterGuidePainter oldDelegate) => false;
}


import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/reward_popup.dart';
import 'package:provider/provider.dart';

class ShapeBuilderPage extends StatefulWidget {
  static const routeName = '/shape-builder';
  const ShapeBuilderPage({super.key});

  @override
  State<ShapeBuilderPage> createState() => _ShapeBuilderPageState();
}

class _ShapeBuilderPageState extends State<ShapeBuilderPage> {
  int _currentLevel = 0;
  final TextToSpeechService _tts = TextToSpeechService();

  // Level Data
  final List<BuilderLevel> _levels = [
    BuilderLevel(
      name: 'House',
      targets: [
        ShapeTarget(id: 'base', shape: ShapeType.square, color: Colors.blue, position: Offset(0, 50), size: 100),
        ShapeTarget(id: 'roof', shape: ShapeType.triangle, color: Colors.red, position: Offset(0, -50), size: 100),
      ],
    ),
    BuilderLevel(
      name: 'Ice Cream',
      targets: [
        ShapeTarget(id: 'cone', shape: ShapeType.triangleInverted, color: Colors.orangeAccent, position: Offset(0, 50), size: 100),
        ShapeTarget(id: 'scoop', shape: ShapeType.circle, color: Colors.pinkAccent, position: Offset(0, -50), size: 90),
      ],
    ),
    BuilderLevel(
      name: 'Train',
      targets: [
        ShapeTarget(id: 'body', shape: ShapeType.rectangle, color: Colors.green, position: Offset(0, -20), size: 120, height: 80),
        ShapeTarget(id: 'wheel1', shape: ShapeType.circle, color: Colors.black, position: Offset(-40, 50), size: 40),
        ShapeTarget(id: 'wheel2', shape: ShapeType.circle, color: Colors.black, position: Offset(40, 50), size: 40),
      ],
    ),
  ];

  // State of placed pieces
  final Set<String> _placedIds = {};

  @override
  void initState() {
    super.initState();
    _tts.init();
    _startLevel();
  }

  void _startLevel() {
    _placedIds.clear();
    Future.delayed(const Duration(milliseconds: 500), () {
      _tts.speak("Let's build a ${_levels[_currentLevel].name}!");
    });
  }

  void _onShapeDropped(ShapeTarget target) {
    setState(() {
      _placedIds.add(target.id);
    });
    SoundManager().playPop();

    if (_placedIds.length == _levels[_currentLevel].targets.length) {
      _handleWin();
    }
  }

  void _handleWin() {
    SoundManager().playSuccess();
    _tts.speak("You built a ${_levels[_currentLevel].name}!");
    Provider.of<RewardsProvider>(context, listen: false).awardStar();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RewardPopup(),
    ).then((_) {
      if (_currentLevel < _levels.length - 1) {
        setState(() {
          _currentLevel++;
        });
        _startLevel();
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final level = _levels[_currentLevel];

    // Identify pieces needed for this level that aren't placed yet
    final List<ShapeTarget> availablePieces = level.targets
        .where((t) => !_placedIds.contains(t.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Build: ${level.name}'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Column(
        children: [
          // 1. Blueprint Area (Center)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Draw Guide/Silhouette for ALL targets
                  ...level.targets.map((target) {
                    final bool isPlaced = _placedIds.contains(target.id);
                    return Positioned(
                      left: (MediaQuery.of(context).size.width / 2) + target.position.dx - (target.size / 2),
                      top: (MediaQuery.of(context).size.height / 3) + target.position.dy - ((target.height ?? target.size) / 2),
                      child: DragTarget<ShapeType>(
                        onWillAccept: (data) => data == target.shape && !isPlaced,
                        onAccept: (data) => _onShapeDropped(target),
                        builder: (context, candidateData, rejectedData) {
                          return Opacity(
                            opacity: isPlaced ? 1.0 : 0.3,
                            child: _ShapeWidget(
                              shape: target.shape,
                              color: isPlaced ? target.color : Colors.grey,
                              size: target.size,
                              height: target.height,
                              isHighlighted: candidateData.isNotEmpty,
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // 2. Parts Bin (Bottom)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availablePieces.map((target) {
                  return Draggable<ShapeType>(
                    data: target.shape,
                    feedback: _ShapeWidget(shape: target.shape, color: target.color, size: target.size, height: target.height),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _ShapeWidget(shape: target.shape, color: target.color, size: 60, height: (target.height != null) ? 40 : 60), // Thumbnail size
                    ),
                    child: _ShapeWidget(shape: target.shape, color: target.color, size: 60, height: (target.height != null) ? 40 : 60),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Shapes & Models ---

enum ShapeType { square, circle, triangle, triangleInverted, rectangle }

class BuilderLevel {
  final String name;
  final List<ShapeTarget> targets;
  BuilderLevel({required this.name, required this.targets});
}

class ShapeTarget {
  final String id;
  final ShapeType shape;
  final Color color;
  final Offset position; // Offset from center
  final double size;
  final double? height; // For non-square shapes like rectangle

  ShapeTarget({
    required this.id,
    required this.shape,
    required this.color,
    required this.position,
    required this.size,
    this.height,
  });
}

class _ShapeWidget extends StatelessWidget {
  final ShapeType shape;
  final Color color;
  final double size;
  final double? height;
  final bool isHighlighted;

  const _ShapeWidget({
    required this.shape,
    required this.color,
    required this.size,
    this.height,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? size;
    final drawColor = isHighlighted ? Colors.greenAccent : color;

    switch (shape) {
      case ShapeType.square:
        return Container(width: size, height: size, color: drawColor);
      case ShapeType.rectangle:
        return Container(width: size, height: effectiveHeight, color: drawColor);
      case ShapeType.circle:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: drawColor, shape: BoxShape.circle),
        );
      case ShapeType.triangle:
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(color: drawColor),
        );
      case ShapeType.triangleInverted:
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(color: drawColor, inverted: true),
        );
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final bool inverted;
  TrianglePainter({required this.color, this.inverted = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (inverted) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    } else {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) => false;
}

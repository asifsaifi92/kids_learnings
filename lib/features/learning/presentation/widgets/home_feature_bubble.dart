// lib/features/learning/presentation/widgets/home_feature_bubble.dart
import 'package:flutter/material.dart';

class HomeFeatureBubble extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;
  final bool isLocked;

  const HomeFeatureBubble({
    super.key,
    required this.label,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  State<HomeFeatureBubble> createState() => _HomeFeatureBubbleState();
}

class _HomeFeatureBubbleState extends State<HomeFeatureBubble> {
  bool _isTapped = false;

  void _onTapDown(_) {
    if (!widget.isLocked) {
      setState(() => _isTapped = true);
    }
  }

  void _onTapUp(_) {
    if (!widget.isLocked) {
      setState(() => _isTapped = false);
      widget.onTap();
    }
  }

  void _onTapCancel() {
    if (!widget.isLocked) {
      setState(() => _isTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isTapped ? 0.95 : 1.0;

    return Column(
      children: [
        AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isLocked ? widget.onTap : null, // Show snackbar for locked items
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [widget.startColor, widget.endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.endColor.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(6, 6),
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 40),
                  if (widget.isLocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.lock, size: 36, color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

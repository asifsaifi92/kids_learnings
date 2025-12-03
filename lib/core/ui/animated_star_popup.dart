// lib/core/ui/animated_star_popup.dart

import 'package:flutter/material.dart';

class AnimatedStarPopup extends StatefulWidget {
  final String message;
  final VoidCallback? onOk;
  const AnimatedStarPopup({Key? key, required this.message, this.onOk}) : super(key: key);

  @override
  State<AnimatedStarPopup> createState() => _AnimatedStarPopupState();
}

class _AnimatedStarPopupState extends State<AnimatedStarPopup> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFFF8A65)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 72),
                const SizedBox(height: 12),
                Text(widget.message, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onOk?.call();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


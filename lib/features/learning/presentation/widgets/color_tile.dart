import 'package:flutter/material.dart';
import '../../domain/entities/color_item.dart';

class ColorTile extends StatefulWidget {
  final ColorItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const ColorTile({
    Key? key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: widget.item.colorValue,
                boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 8),
                    blurRadius: 15,
                )
                ],
                border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 3,
                ),
            ),
            child: Center(
                child: Text(
                widget.item.displayText,
                style: TextStyle(
                    color: widget.item.colorValue.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                    )
                    ],
                ),
                ),
            ),
        ),
      ),
    );
  }
}

// lib/features/rhymes/presentation/widgets/rhyme_lyrics.dart
import 'package:flutter/material.dart';

class RhymeLyrics extends StatelessWidget {
  final String text;
  final int activeWordIndex;
  final TextStyle? style;
  final TextStyle? activeStyle;

  const RhymeLyrics({
    super.key,
    required this.text,
    required this.activeWordIndex,
    this.style,
    this.activeStyle,
  });

  List<String> _splitToWords(String text) {
    if (text.trim().isEmpty) return [];
    return text.trim().split(RegExp(r"\s+"));
  }

  @override
  Widget build(BuildContext context) {
    final words = _splitToWords(text);
    final defaultStyle = style ?? const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, height: 1.5);
    final highlightStyle = activeStyle ?? defaultStyle.copyWith(color: Colors.yellowAccent, fontSize: defaultStyle.fontSize! * 1.05);

    // Build InlineSpan list with WidgetSpan for active word to allow animation
    final spans = <InlineSpan>[];
    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      final isActive = i == activeWordIndex;

      if (isActive) {
        // Animated active word: scale + fade
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 1.08),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: 1.0,
                  child: child,
                ),
              );
            },
            child: Text(
              word,
              style: highlightStyle,
            ),
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: word,
          style: defaultStyle,
        ));
      }

      if (i != words.length - 1) spans.add(const TextSpan(text: ' '));
    }

    return DefaultTextStyle(
      style: defaultStyle,
      textAlign: TextAlign.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: spans),
      ),
    );
  }
}

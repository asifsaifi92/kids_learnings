// lib/features/colors/domain/entities/color_item.dart

class ColorItem {
  final int id;
  final String name;
  final String displayText;
  final String colorHex;
  final String ttsText;

  const ColorItem({
    required this.id,
    required this.name,
    required this.displayText,
    required this.colorHex,
    required this.ttsText,
  });
}


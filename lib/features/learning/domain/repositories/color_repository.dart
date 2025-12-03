import '../entities/color_item.dart';

abstract class ColorRepository {
  Future<List<ColorItem>> getColorItems();
}

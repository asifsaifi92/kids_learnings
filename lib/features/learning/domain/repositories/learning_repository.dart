import '../entities/alphabet_item.dart';
import '../entities/number_item.dart';
import '../entities/color_item.dart';
import '../entities/shape_item.dart';

abstract class LearningRepository {
  List<AlphabetItem> getAlphabetItems();
  List<NumberItem> getNumberItems();
  Future<List<ColorItem>> getColorItems();
  Future<List<ShapeItem>> getShapeItems();
}

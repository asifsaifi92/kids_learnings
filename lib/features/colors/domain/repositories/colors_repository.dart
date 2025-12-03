// lib/features/colors/domain/repositories/colors_repository.dart

import '../entities/color_item.dart';

abstract class ColorsRepository {
  Future<List<ColorItem>> getColors();
}


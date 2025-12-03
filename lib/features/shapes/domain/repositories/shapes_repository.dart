// lib/features/shapes/domain/repositories/shapes_repository.dart

import '../entities/shape_item.dart';

abstract class ShapesRepository {
  Future<List<ShapeItem>> getShapeItems();
}

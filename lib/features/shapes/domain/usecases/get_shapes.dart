// lib/features/shapes/domain/usecases/get_shapes.dart

import '../entities/shape_item.dart';
import '../repositories/shapes_repository.dart';

class GetShapes {
  final ShapesRepository repository;

  GetShapes(this.repository);

  Future<List<ShapeItem>> call() {
    return repository.getShapeItems();
  }
}

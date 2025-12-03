// lib/features/shapes/data/repositories/shapes_repository_impl.dart

import '../../domain/entities/shape_item.dart';
import '../../domain/repositories/shapes_repository.dart';
import '../datasources/shapes_local_data_source.dart';

class ShapesRepositoryImpl implements ShapesRepository {
  final ShapesLocalDataSource localDataSource;

  ShapesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ShapeItem>> getShapeItems() {
    return localDataSource.getShapeItems();
  }
}

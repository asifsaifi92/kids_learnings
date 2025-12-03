import '''../entities/shape_item.dart''';
import '''../repositories/learning_repository.dart''';

class GetShapeItems {
  final LearningRepository repository;

  GetShapeItems(this.repository);

  Future<List<ShapeItem>> call() async {
    return await repository.getShapeItems();
  }
}

import '''../entities/color_item.dart''';
import '''../repositories/learning_repository.dart''';

class GetColorItems {
  final LearningRepository repository;

  GetColorItems(this.repository);

  Future<List<ColorItem>> call() async {
    return await repository.getColorItems();
  }
}

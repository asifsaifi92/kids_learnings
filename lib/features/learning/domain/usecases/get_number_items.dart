// lib/features/learning/domain/usecases/get_number_items.dart
import '../entities/number_item.dart';
import '../repositories/learning_repository.dart';

class GetNumberItems {
  final LearningRepository repository;

  GetNumberItems(this.repository);

  List<NumberItem> call() {
    return repository.getNumberItems();
  }
}

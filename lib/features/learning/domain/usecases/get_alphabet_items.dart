// lib/features/learning/domain/usecases/get_alphabet_items.dart
import '../entities/alphabet_item.dart';
import '../repositories/learning_repository.dart';

class GetAlphabetItems {
  final LearningRepository repository;

  GetAlphabetItems(this.repository);

  List<AlphabetItem> call() {
    return repository.getAlphabetItems();
  }
}

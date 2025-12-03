import '../../domain/entities/alphabet_item.dart';
import '../../domain/entities/number_item.dart';
import '../../domain/entities/color_item.dart';
import '../../domain/entities/shape_item.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_local_data_source.dart';

class LearningRepositoryImpl implements LearningRepository {
  final LearningLocalDataSource localDataSource;

  LearningRepositoryImpl({required this.localDataSource});

  @override
  List<AlphabetItem> getAlphabetItems() {
    return localDataSource.getAlphabetItems();
  }

  @override
  List<NumberItem> getNumberItems() {
    return localDataSource.getNumberItems();
  }

  @override
  Future<List<ColorItem>> getColorItems() async {
    return localDataSource.getColorItems();
  }

  @override
  Future<List<ShapeItem>> getShapeItems() async {
    return localDataSource.getShapeItems();
  }
}

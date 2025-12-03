import '''../../domain/entities/color_item.dart''';
import '''../../domain/repositories/color_repository.dart''';
import '''../datasources/color_local_data_source.dart''';

class ColorRepositoryImpl implements ColorRepository {
  final ColorLocalDataSource localDataSource;

  ColorRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ColorItem>> getColorItems() async {
    final colorModels = await localDataSource.getColorItems();
    return colorModels;
  }
}

// lib/features/colors/data/repositories/colors_repository_impl.dart

import '../../domain/entities/color_item.dart';
import '../../domain/repositories/colors_repository.dart';
import '../datasources/colors_local_data_source.dart';

class ColorsRepositoryImpl implements ColorsRepository {
  final ColorsLocalDataSource localDataSource;
  ColorsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ColorItem>> getColors() async {
    return await localDataSource.getColors();
  }
}


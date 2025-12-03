// lib/features/colors/domain/usecases/get_colors.dart

import '../repositories/colors_repository.dart';
import '../entities/color_item.dart';

class GetColors {
  final ColorsRepository repository;
  GetColors(this.repository);

  Future<List<ColorItem>> call() async {
    return await repository.getColors();
  }
}


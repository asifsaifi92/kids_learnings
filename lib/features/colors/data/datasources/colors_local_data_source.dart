// lib/features/colors/data/datasources/colors_local_data_source.dart

import '../../domain/entities/color_item.dart';

abstract class ColorsLocalDataSource {
  Future<List<ColorItem>> getColors();
}

class ColorsLocalDataSourceImpl implements ColorsLocalDataSource {
  @override
  Future<List<ColorItem>> getColors() async {
    await Future.delayed(const Duration(milliseconds: 60));
    return const [
      ColorItem(id: 1, name: 'Red', displayText: 'Red', colorHex: '#F44336', ttsText: 'This is red'),
      ColorItem(id: 2, name: 'Blue', displayText: 'Blue', colorHex: '#2196F3', ttsText: 'This is blue'),
      ColorItem(id: 3, name: 'Green', displayText: 'Green', colorHex: '#4CAF50', ttsText: 'This is green'),
      ColorItem(id: 4, name: 'Yellow', displayText: 'Yellow', colorHex: '#FFEB3B', ttsText: 'This is yellow'),
      ColorItem(id: 5, name: 'Orange', displayText: 'Orange', colorHex: '#FF9800', ttsText: 'This is orange'),
      ColorItem(id: 6, name: 'Purple', displayText: 'Purple', colorHex: '#9C27B0', ttsText: 'This is purple'),
      ColorItem(id: 7, name: 'Pink', displayText: 'Pink', colorHex: '#E91E63', ttsText: 'This is pink'),
      ColorItem(id: 8, name: 'Brown', displayText: 'Brown', colorHex: '#795548', ttsText: 'This is brown'),
      ColorItem(id: 9, name: 'Gray', displayText: 'Gray', colorHex: '#9E9E9E', ttsText: 'This is gray'),
      ColorItem(id: 10, name: 'Black', displayText: 'Black', colorHex: '#000000', ttsText: 'This is black'),
    ];
  }
}

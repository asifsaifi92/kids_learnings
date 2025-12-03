
import 'package:flutter/material.dart';
import '../models/color_model.dart';

abstract class ColorLocalDataSource {
  Future<List<ColorModel>> getColorItems();
}

class ColorLocalDataSourceImpl implements ColorLocalDataSource {
  @override
  Future<List<ColorModel>> getColorItems() async {
    // In a real app, this could come from a database or a file
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    return const [
      ColorModel(id: 1, name: 'Red', displayText: 'Red', colorValue: Colors.red, ttsText: 'Red'),
      ColorModel(id: 2, name: 'Blue', displayText: 'Blue', colorValue: Colors.blue, ttsText: 'Blue'),
      ColorModel(id: 3, name: 'Green', displayText: 'Green', colorValue: Colors.green, ttsText: 'Green'),
      ColorModel(id: 4, name: 'Yellow', displayText: 'Yellow', colorValue: Colors.yellow, ttsText: 'Yellow'),
      ColorModel(id: 5, name: 'Orange', displayText: 'Orange', colorValue: Colors.orange, ttsText: 'Orange'),
      ColorModel(id: 6, name: 'Purple', displayText: 'Purple', colorValue: Colors.purple, ttsText: 'Purple'),
      ColorModel(id: 7, name: 'Pink', displayText: 'Pink', colorValue: Colors.pink, ttsText: 'Pink'),
      ColorModel(id: 8, name: 'Brown', displayText: 'Brown', colorValue: Colors.brown, ttsText: 'Brown'),
      ColorModel(id: 9, name: 'Black', displayText: 'Black', colorValue: Colors.black, ttsText: 'Black'),
      ColorModel(id: 10, name: 'White', displayText: 'White', colorValue: Colors.white, ttsText: 'White'),
    ];
  }
}

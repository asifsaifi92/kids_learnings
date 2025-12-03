// lib/features/shapes/presentation/provider/shapes_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';
import '../../domain/usecases/get_shapes.dart';
import '../../../../core/services/text_to_speech_service.dart';

class ShapesProvider extends ChangeNotifier {
  final GetShapes getShapes;
  final TextToSpeechService ttsService;

  ShapesProvider({required this.getShapes, required this.ttsService});

  List<ShapeItem> _items = [];
  List<ShapeItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getShapes.call();
    _isLoading = false;
    notifyListeners();
  }

  void speak(ShapeItem item) {
    final text = (item.ttsText).trim().isNotEmpty ? item.ttsText : item.displayText;
    // ignore: avoid_print
    print('[ShapesProvider] speak: id=${item.id} name=${item.name} text="$text"');
    ttsService.speak(text);
  }
}

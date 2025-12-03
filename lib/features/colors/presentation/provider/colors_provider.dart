// lib/features/colors/presentation/provider/colors_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/color_item.dart';
import '../../domain/usecases/get_colors.dart';
import '../../../../core/services/text_to_speech_service.dart';

class ColorsProvider extends ChangeNotifier {
  final GetColors getColors;
  final TextToSpeechService ttsService;

  ColorsProvider({required this.getColors, required this.ttsService});

  List<ColorItem> _items = [];
  List<ColorItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getColors.call();
    _isLoading = false;
    notifyListeners();
  }

  void speak(ColorItem item) {
    // Ensure we always send a meaningful non-empty string to TTS.
    final text = (item.ttsText).trim().isNotEmpty ? item.ttsText : item.displayText;
    // Small debug log (visible in console) to help debugging which text is sent to TTS.
    // ignore: avoid_print
    print('[ColorsProvider] speak: id=${item.id} name=${item.name} text="$text"');
    ttsService.speak(text);
  }
}

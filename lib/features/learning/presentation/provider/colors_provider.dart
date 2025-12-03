import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/color_item.dart';
import '../../domain/usecases/get_color_items.dart';
import '../../../../core/services/text_to_speech_service.dart';

enum GameState { none, asking, correct, wrong }

class ColorsProvider extends ChangeNotifier {
  final GetColorItems getColorItems;
  final TextToSpeechService ttsService;

  ColorsProvider({required this.getColorItems, required this.ttsService});

  List<ColorItem> _items = [];
  List<ColorItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GameState _gameState = GameState.none;
  GameState get gameState => _gameState;

  ColorItem? _currentTarget;
  ColorItem? get currentTarget => _currentTarget;

  List<ColorItem> _gameChoices = [];
  List<ColorItem> get gameChoices => _gameChoices;

  Future<void> loadColors() async {
    _isLoading = true;
    notifyListeners();
    // In a real app, you would handle potential errors here
    final result = await getColorItems.call();
    _items = result;
    _isLoading = false;
    notifyListeners();
  }

  void speakColor(ColorItem item) {
    ttsService.speak(item.ttsText);
  }

  void startMiniGame() {
    if (_items.length < 3) return;

    _gameState = GameState.asking;
    final random = Random();
    
    final shuffledItems = List<ColorItem>.from(_items)..shuffle(random);
    
    _gameChoices = shuffledItems.take(3).toList();
    
    _currentTarget = _gameChoices[random.nextInt(_gameChoices.length)];

    ttsService.speak('Tap the ${_currentTarget!.name} color!');
    notifyListeners();
  }

  void checkAnswer(ColorItem selectedItem) {
    if (_currentTarget == null || _gameState != GameState.asking) return;

    if (selectedItem.id == _currentTarget!.id) {
      _gameState = GameState.correct;
      ttsService.speak('Great job!');
      // You can add a star award here later
      Future.delayed(const Duration(seconds: 2), () {
          startMiniGame();
      });
    } else {
      _gameState = GameState.wrong;
      ttsService.speak('Try again!');
      Future.delayed(const Duration(seconds: 1), () {
          _gameState = GameState.asking;
          notifyListeners();
      });
    }
    notifyListeners();
  }

  void resetGame() {
    _gameState = GameState.none;
    _currentTarget = null;
    _gameChoices = [];
    notifyListeners();
  }
}

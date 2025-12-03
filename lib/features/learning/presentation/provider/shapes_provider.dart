import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/shape_item.dart';
import '../../domain/usecases/get_shape_items.dart';
import '../../../../core/services/text_to_speech_service.dart';

enum ShapeGameState { none, asking, correct, wrong }

class ShapesProvider extends ChangeNotifier {
  final GetShapeItems getShapeItems;
  final TextToSpeechService ttsService;

  ShapesProvider({required this.getShapeItems, required this.ttsService});

  List<ShapeItem> _items = [];
  List<ShapeItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ShapeGameState _gameState = ShapeGameState.none;
  ShapeGameState get gameState => _gameState;

  ShapeItem? _currentTarget;
  ShapeItem? get currentTarget => _currentTarget;

  List<ShapeItem> _gameChoices = [];
  List<ShapeItem> get gameChoices => _gameChoices;

  Future<void> loadShapes() async {
    _isLoading = true;
    notifyListeners();
    final result = await getShapeItems.call();
    _items = result;
    _isLoading = false;
    notifyListeners();
  }

  void speakShape(ShapeItem item) {
    ttsService.speak(item.ttsText);
  }

  void startMiniGame() {
    if (_items.length < 3) return;

    _gameState = ShapeGameState.asking;
    final random = Random();
    
    final shuffledItems = List<ShapeItem>.from(_items)..shuffle(random);
    
    _gameChoices = shuffledItems.take(3).toList();
    
    _currentTarget = _gameChoices[random.nextInt(_gameChoices.length)];

    ttsService.speak('Find the ${_currentTarget!.name}!');
    notifyListeners();
  }

  void checkAnswer(ShapeItem selectedItem) {
    if (_currentTarget == null || _gameState != ShapeGameState.asking) return;

    if (selectedItem.id == _currentTarget!.id) {
      _gameState = ShapeGameState.correct;
      ttsService.speak('Awesome!');
      Future.delayed(const Duration(seconds: 2), () {
          startMiniGame();
      });
    } else {
      _gameState = ShapeGameState.wrong;
      ttsService.speak('Oops, try again!');
      Future.delayed(const Duration(seconds: 1), () {
          _gameState = ShapeGameState.asking;
          notifyListeners();
      });
    }
    notifyListeners();
  }

  void resetGame() {
    _gameState = ShapeGameState.none;
    _currentTarget = null;
    _gameChoices = [];
    notifyListeners();
  }
}

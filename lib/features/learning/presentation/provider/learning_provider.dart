// lib/features/learning/presentation/provider/learning_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningProvider extends ChangeNotifier {
  LearningProvider();

  Set<String> _completedAlphabets = {};
  Set<String> get completedAlphabets => _completedAlphabets;

  Set<String> _completedNumbers = {};
  Set<String> get completedNumbers => _completedNumbers;

  Set<String> _completedColors = {};
  Set<String> get completedColors => _completedColors;

  Set<String> _completedShapes = {};
  Set<String> get completedShapes => _completedShapes;

  /// Call this during app initialization to load persisted progress.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _completedAlphabets = (prefs.getStringList('completed_alphabets') ?? []).toSet();
    _completedNumbers = (prefs.getStringList('completed_numbers') ?? []).toSet();
    _completedColors = (prefs.getStringList('completed_colors') ?? []).toSet();
    _completedShapes = (prefs.getStringList('completed_shapes') ?? []).toSet();
    notifyListeners();
  }

  /// Marks an alphabet letter as learned and saves progress.
  Future<void> markAlphabetAsLearned(String letter) async {
    if (_completedAlphabets.add(letter)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_alphabets', _completedAlphabets.toList());
      notifyListeners();
    }
  }

  /// Marks a number as learned and saves progress.
  Future<void> markNumberAsLearned(String number) async {
    if (_completedNumbers.add(number)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_numbers', _completedNumbers.toList());
      notifyListeners();
    }
  }

  /// Marks a color as learned and saves progress.
  Future<void> markColorAsLearned(String colorName) async {
    if (_completedColors.add(colorName)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_colors', _completedColors.toList());
      notifyListeners();
    }
  }

  /// Marks a shape as learned and saves progress.
  Future<void> markShapeAsLearned(String shapeName) async {
    if (_completedShapes.add(shapeName)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_shapes', _completedShapes.toList());
      notifyListeners();
    }
  }
}

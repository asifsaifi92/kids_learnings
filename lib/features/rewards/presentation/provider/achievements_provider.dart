
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconAsset; // Or generic icon data
  final int target;
  int progress;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.target,
    this.progress = 0,
    this.isUnlocked = false,
  });
}

class AchievementsProvider extends ChangeNotifier {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'bookworm',
      title: 'Bookworm',
      description: 'Read 3 Stories',
      iconAsset: 'assets/images/stories/book_badge.png', // Placeholder
      target: 3,
    ),
    Achievement(
      id: 'artist',
      title: 'Little Artist',
      description: 'Save 3 Drawings',
      iconAsset: 'assets/icons/palette.png',
      target: 3,
    ),
    Achievement(
      id: 'math_whiz',
      title: 'Math Whiz',
      description: 'Trace 3 Numbers',
      iconAsset: 'assets/icons/calculator.png',
      target: 3,
    ),
    Achievement(
      id: 'puzzle_master',
      title: 'Puzzle Master',
      description: 'Solve 3 Puzzles',
      iconAsset: 'assets/icons/puzzle.png',
      target: 3,
    ),
    Achievement(
      id: 'pet_sitter',
      title: 'Best Friend',
      description: 'Feed Mascot 5 times',
      iconAsset: 'assets/icons/pet_food.png',
      target: 5,
    ),
  ];

  List<Achievement> get achievements => _achievements;

  // Stream/Callback for UI popup
  Achievement? _latestUnlocked;
  Achievement? get latestUnlocked => _latestUnlocked;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    for (var ach in _achievements) {
      ach.progress = prefs.getInt('ach_prog_${ach.id}') ?? 0;
      ach.isUnlocked = prefs.getBool('ach_unlocked_${ach.id}') ?? false;
    }
    notifyListeners();
  }

  Future<void> incrementProgress(String id) async {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final ach = _achievements[index];
    if (ach.isUnlocked) return; // Already done

    ach.progress++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ach_prog_${ach.id}', ach.progress);

    if (ach.progress >= ach.target) {
      ach.isUnlocked = true;
      await prefs.setBool('ach_unlocked_${ach.id}', true);
      
      // Trigger unlock event
      _latestUnlocked = ach;
      SoundManager().playSuccess();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void clearLatestUnlocked() {
    _latestUnlocked = null;
    notifyListeners();
  }
}

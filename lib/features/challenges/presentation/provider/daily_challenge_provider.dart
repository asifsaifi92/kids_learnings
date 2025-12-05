// lib/features/challenges/presentation/provider/daily_challenge_provider.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum to represent the different types of challenges available
enum ChallengeType {
  CompleteQuizzes,
  LearnLetters,
  LearnNumbers,
  LearnColors,
  LearnShapes,
  ReadStories,
  DrawSomething,
}

// Represents a single daily challenge
class DailyChallenge {
  final String id;
  final String description;
  final ChallengeType type;
  final int targetCount;
  int currentProgress;

  DailyChallenge({
    required this.id,
    required this.description,
    required this.type,
    required this.targetCount,
    this.currentProgress = 0,
  });

  bool get isCompleted => currentProgress >= targetCount;

  // Serialization methods to store in SharedPreferences
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'type': type.toString(),
        'targetCount': targetCount,
        'currentProgress': currentProgress,
      };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) => DailyChallenge(
        id: json['id'],
        description: json['description'],
        type: ChallengeType.values.firstWhere((e) => e.toString() == json['type']),
        targetCount: json['targetCount'],
        currentProgress: json['currentProgress'],
      );
}

class DailyChallengeProvider extends ChangeNotifier {
  DailyChallengeProvider();

  // --- State ---
  List<DailyChallenge> _challenges = [];
  DateTime? _lastGeneratedDate;
  bool _dailyBonusClaimed = false;

  // --- Getters ---
  List<DailyChallenge> get challenges => _challenges;
  bool get allChallengesCompleted => _challenges.isNotEmpty && _challenges.every((c) => c.isCompleted);
  bool get dailyBonusClaimed => _dailyBonusClaimed;

  // --- Methods ---

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString('last_challenge_date');
    final today = DateUtils.dateOnly(DateTime.now());

    if (lastDateString != null) {
      _lastGeneratedDate = DateTime.parse(lastDateString);
    }

    if (_lastGeneratedDate == null || !DateUtils.isSameDay(_lastGeneratedDate, today)) {
      _generateNewChallenges(prefs);
    } else {
      _loadChallenges(prefs);
    }
    notifyListeners();
  }

  void _generateNewChallenges(SharedPreferences prefs) {
    final allPossibleChallenges = [
      DailyChallenge(id: 'quiz1', description: 'Complete 1 Quiz', type: ChallengeType.CompleteQuizzes, targetCount: 1),
      DailyChallenge(id: 'letters3', description: 'Learn 3 New Letters', type: ChallengeType.LearnLetters, targetCount: 3),
      DailyChallenge(id: 'numbers3', description: 'Learn 3 New Numbers', type: ChallengeType.LearnNumbers, targetCount: 3),
      DailyChallenge(id: 'colors2', description: 'Learn 2 New Colors', type: ChallengeType.LearnColors, targetCount: 2),
      DailyChallenge(id: 'shapes2', description: 'Learn 2 New Shapes', type: ChallengeType.LearnShapes, targetCount: 2),
      DailyChallenge(id: 'story1', description: 'Read 1 Story', type: ChallengeType.ReadStories, targetCount: 1),
      DailyChallenge(id: 'draw1', description: 'Save 1 Drawing', type: ChallengeType.DrawSomething, targetCount: 1),
    ];

    allPossibleChallenges.shuffle();
    _challenges = allPossibleChallenges.take(3).toList();
    _dailyBonusClaimed = false;

    _lastGeneratedDate = DateUtils.dateOnly(DateTime.now());
    prefs.setString('last_challenge_date', _lastGeneratedDate!.toIso8601String());
    prefs.setBool('daily_bonus_claimed', _dailyBonusClaimed);
    _saveChallenges(prefs);
  }

  void _loadChallenges(SharedPreferences prefs) {
    final challengesJson = prefs.getStringList('daily_challenges') ?? [];
    _challenges = challengesJson.map((json) => DailyChallenge.fromJson(jsonDecode(json))).toList();
    _dailyBonusClaimed = prefs.getBool('daily_bonus_claimed') ?? false;
  }

  void _saveChallenges(SharedPreferences prefs) {
    final challengesJson = _challenges.map((c) => jsonEncode(c.toJson())).toList();
    prefs.setStringList('daily_challenges', challengesJson);
  }

  Future<void> updateProgress(ChallengeType type, {int amount = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    bool challengeUpdated = false;

    for (var challenge in _challenges) {
      if (challenge.type == type && !challenge.isCompleted) {
        challenge.currentProgress += amount;
        challengeUpdated = true;
      }
    }

    if (challengeUpdated) {
      _saveChallenges(prefs);
      notifyListeners();
    }
  }

  Future<void> claimDailyBonus() async {
    if (allChallengesCompleted && !_dailyBonusClaimed) {
      _dailyBonusClaimed = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('daily_bonus_claimed', true);
      notifyListeners();
    }
  }
}

// lib/features/rewards/presentation/provider/rewards_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/reward_state.dart';
import '../../domain/usecases/get_rewards.dart';
import '../../domain/usecases/award_star.dart';
import '../../domain/usecases/spend_star.dart';

class RewardsProvider extends ChangeNotifier {
  final GetRewards getRewards;
  final AwardStar awardStarUseCase;
  final SpendStar spendStarUseCase;

  RewardsProvider({
    required this.getRewards,
    required this.awardStarUseCase,
    required this.spendStarUseCase,
  });

  RewardState _rewardState = RewardState(totalStars: 0);
  RewardState get rewardState => _rewardState;

  // Streak State
  int _currentStreak = 1;
  int get currentStreak => _currentStreak;
  
  bool _canClaimDailyReward = false;
  bool get canClaimDailyReward => _canClaimDailyReward;

  final _rewardPopupController = StreamController<void>.broadcast();
  Stream<void> get rewardPopupStream => _rewardPopupController.stream;

  Future<void> load() async {
    _rewardState = await getRewards();
    await _checkDailyLoginStatus();
    notifyListeners();
  }

  Future<void> awardStar() async {
    await awardStarUseCase();
    _rewardState = await getRewards();
    _rewardPopupController.add(null);
    notifyListeners();
  }
  
  // Award multiple stars without triggering popup stream every time
  Future<void> awardStars(int amount) async {
    for(int i=0; i<amount; i++) {
        await awardStarUseCase();
    }
    _rewardState = await getRewards();
    notifyListeners();
  }

  Future<void> spendStars(int starsToSpend) async {
    await spendStarUseCase(starsToSpend);
    _rewardState = await getRewards();
    notifyListeners();
  }

  // --- Daily Login Logic ---

  Future<void> _checkDailyLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString('last_daily_login_date');
    final lastStreak = prefs.getInt('daily_streak_count') ?? 0;
    
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}"; // Simple YYYY-MM-DD

    if (lastLoginStr == null) {
      // First time ever
      _currentStreak = 1;
      _canClaimDailyReward = true;
    } else if (lastLoginStr == todayStr) {
      // Already logged in today
      _currentStreak = lastStreak;
      _canClaimDailyReward = false; // Already claimed or checked
      // Check if actually claimed
      final claimed = prefs.getBool('daily_reward_claimed_today') ?? false;
      _canClaimDailyReward = !claimed;
    } else {
      // Check if it was yesterday
      final lastDate = DateTime.parse(lastLoginStr); // This parses YYYY-MM-DD correctly if simple
      // Re-parse purely to strip time logic
      final lastDateMidnight = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final todayMidnight = DateTime(now.year, now.month, now.day);
      
      final difference = todayMidnight.difference(lastDateMidnight).inDays;

      if (difference == 1) {
        // Consecutive day!
        _currentStreak = lastStreak + 1;
      } else {
        // Missed a day
        _currentStreak = 1;
      }
      _canClaimDailyReward = true;
      
      // Reset the "claimed" flag for the new day
      await prefs.setBool('daily_reward_claimed_today', false);
    }
    
    // Save updated streak (but don't save date until claimed usually, 
    // but here we track streak persistence even if not claimed yet)
    // Actually, let's just save streak now so it persists.
    await prefs.setInt('daily_streak_count', _currentStreak);
  }

  Future<void> claimDailyReward() async {
    if (!_canClaimDailyReward) return;

    // Calculate Reward based on streak (Day 1..7)
    // Day 7 gives big bonus!
    int dayInCycle = (_currentStreak - 1) % 7 + 1;
    int rewardAmount = dayInCycle * 5; // 5, 10, 15...
    if (dayInCycle == 7) rewardAmount = 100; // Big bonus!

    await awardStars(rewardAmount);

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    
    await prefs.setString('last_daily_login_date', todayStr);
    await prefs.setBool('daily_reward_claimed_today', true);
    
    _canClaimDailyReward = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _rewardPopupController.close();
    super.dispose();
  }
}

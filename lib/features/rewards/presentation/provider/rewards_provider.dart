// lib/features/rewards/presentation/provider/rewards_provider.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../domain/entities/reward_state.dart';
import '../../domain/usecases/get_rewards.dart';
import '../../domain/usecases/award_star.dart';

class RewardsProvider extends ChangeNotifier {
  final GetRewards getRewards;
  final AwardStar awardStarUseCase;

  RewardsProvider({required this.getRewards, required this.awardStarUseCase});

  RewardState _rewardState = RewardState(totalStars: 0);
  RewardState get rewardState => _rewardState;

  final _rewardPopupController = StreamController<void>.broadcast();
  Stream<void> get rewardPopupStream => _rewardPopupController.stream;

  Future<void> load() async {
    _rewardState = await getRewards();
    notifyListeners();
  }

  Future<void> awardStar() async {
    await awardStarUseCase();
    _rewardState = await getRewards();
    _rewardPopupController.add(null);
    notifyListeners();
  }

  @override
  void dispose() {
    _rewardPopupController.close();
    super.dispose();
  }
}

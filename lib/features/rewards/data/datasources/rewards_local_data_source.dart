// lib/features/rewards/data/datasources/rewards_local_data_source.dart

import '../../domain/entities/reward_state.dart';

abstract class RewardsLocalDataSource {
  Future<RewardState> getRewards();
  Future<void> awardStar();
}

class RewardsLocalDataSourceImpl implements RewardsLocalDataSource {
  int _starCount = 0;

  @override
  Future<RewardState> getRewards() async {
    return RewardState(totalStars: _starCount);
  }

  @override
  Future<void> awardStar() async {
    _starCount++;
  }
}

// lib/features/rewards/domain/repositories/rewards_repository.dart

import '../entities/reward_state.dart';

abstract class RewardsRepository {
  Future<RewardState> getRewards();
  Future<void> awardStar();
  Future<void> spendStars(int starsToSpend);
}

// lib/features/rewards/domain/usecases/get_rewards.dart

import '../entities/reward_state.dart';
import '../repositories/rewards_repository.dart';

class GetRewards {
  final RewardsRepository repository;

  GetRewards(this.repository);

  Future<RewardState> call() {
    return repository.getRewards();
  }
}

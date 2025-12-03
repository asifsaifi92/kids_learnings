// lib/features/rewards/data/repositories/rewards_repository_impl.dart

import '../../domain/entities/reward_state.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_local_data_source.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsLocalDataSource localDataSource;

  RewardsRepositoryImpl({required this.localDataSource});

  @override
  Future<RewardState> getRewards() {
    return localDataSource.getRewards();
  }

  @override
  Future<void> awardStar() {
    return localDataSource.awardStar();
  }
}

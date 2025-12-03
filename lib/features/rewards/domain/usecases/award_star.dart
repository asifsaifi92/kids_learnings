// lib/features/rewards/domain/usecases/award_star.dart

import '../repositories/rewards_repository.dart';

class AwardStar {
  final RewardsRepository repository;

  AwardStar(this.repository);

  Future<void> call() {
    return repository.awardStar();
  }
}

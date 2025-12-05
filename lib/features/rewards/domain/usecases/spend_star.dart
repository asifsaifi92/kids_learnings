// lib/features/rewards/domain/usecases/spend_star.dart

import '../repositories/rewards_repository.dart';

class SpendStar {
  final RewardsRepository repository;

  SpendStar(this.repository);

  Future<void> call(int starsToSpend) async {
    await repository.spendStars(starsToSpend);
  }
}

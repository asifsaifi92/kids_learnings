// lib/features/rewards/domain/entities/reward_state.dart

class RewardState {
  final int totalStars;
  final String? lastEarnedMessage;

  RewardState({required this.totalStars, this.lastEarnedMessage});
}

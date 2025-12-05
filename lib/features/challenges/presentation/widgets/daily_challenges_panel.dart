// lib/features/challenges/presentation/widgets/daily_challenges_panel.dart

import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class DailyChallengesPanel extends StatelessWidget {
  const DailyChallengesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyChallengeProvider>(
      builder: (context, provider, child) {
        if (provider.challenges.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Goals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...provider.challenges.map((challenge) => _buildChallengeRow(challenge)),
              const SizedBox(height: 12),
              _buildBonusSection(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengeRow(DailyChallenge challenge) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            challenge.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: challenge.isCompleted ? Colors.green : Colors.grey.shade600,
          ),
          const SizedBox(width: 10),
          Text(
            challenge.description,
            style: TextStyle(
              fontSize: 16,
              color: challenge.isCompleted ? Colors.grey.shade700 : Colors.black,
              decoration: challenge.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusSection(BuildContext context, DailyChallengeProvider provider) {
    if (provider.allChallengesCompleted) {
      if (provider.dailyBonusClaimed) {
        return const Center(
          child: Text(
            'Come back tomorrow for new goals!',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      } else {
        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final rewardsProvider = context.read<RewardsProvider>();
              // Award bonus stars
              for (int i = 0; i < 5; i++) {
                rewardsProvider.awardStar();
              }
              // Mark bonus as claimed
              provider.claimDailyBonus();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You earned a 5-star bonus!')),
              );
            },
            child: const Text('Claim Bonus!'),
          ),
        );
      }
    } else {
      return const SizedBox.shrink(); // No bonus until all challenges are done
    }
  }
}

// lib/features/challenges/presentation/widgets/todays_goals_card.dart

import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class TodaysGoalsCard extends StatelessWidget {
  const TodaysGoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyChallengeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Today's Goals",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              ...provider.challenges.map((challenge) => _buildChallengeRow(challenge)),
              const SizedBox(height: 20),
              _buildBonusSection(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengeRow(DailyChallenge challenge) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: Icon(
              challenge.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              key: ValueKey<bool>(challenge.isCompleted), // Important for animation
              color: challenge.isCompleted ? Colors.greenAccent.shade400 : Colors.white.withOpacity(0.8),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            challenge.description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              decoration: challenge.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white.withOpacity(0.7),
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Come back tomorrow for new goals!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        );
      } else {
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              final rewardsProvider = context.read<RewardsProvider>();
              for (int i = 0; i < 5; i++) {
                rewardsProvider.awardStar();
              }
              provider.claimDailyBonus();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You earned a 5-star bonus!')),
              );
            },
            icon: const Icon(Icons.star, color: Colors.white),
            label: const Text('Claim Bonus!', style: TextStyle(fontSize: 18, color: Colors.black87)),
          ),
        );
      }
    } else {
      return const SizedBox.shrink(); // No bonus until all challenges are done
    }
  }
}

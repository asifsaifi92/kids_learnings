
import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/widgets/todays_goals_card.dart';
import 'package:kids/features/parent_settings/presentation/pages/parent_settings_page.dart';
import 'package:provider/provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'home_page_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  void _showGoalsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const TodaysGoalsCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          CartoonBackground(),
          SafeArea(
            child: Column(
              children: [
                _TopHeader(),
                Expanded(
                  child: FeatureCarousel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StarCounter(),
          Row(
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const TodaysGoalsCard(),
                ),
                child: Container(
                   padding: const EdgeInsets.all(10),
                   decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                     boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), 
                        offset: const Offset(0, 4), 
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, ParentSettingsPage.routeName),
                child: const SettingsButton(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

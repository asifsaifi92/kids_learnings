// lib/features/learning/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:kids/features/parent_settings/presentation/pages/parent_settings_page.dart';
import 'package:provider/provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'home_page_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return const Scaffold(
      body: Stack(
        children: [
          // Background
          CartoonBackground(),

          // Mascot
          Align(
            alignment: Alignment(0.8, -0.5),
            child: CartoonMascot(size: 120),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopHeader(),
                Expanded(
                  child: Center(
                    child: WelcomeMessage(),
                  ),
                ),
                _BottomPanel(),
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
    final rewardsProvider = Provider.of<RewardsProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StarCounter(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, ParentSettingsPage.routeName),
            child: const SettingsButton(),
          ),
        ],
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel();

  @override
  Widget build(BuildContext context) {
    return const BubblyBottomPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, top: 24),
            child: Text("Let's Learn!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LearningWorldsGrid(),
          ),
        ],
      ),
    );
  }
}

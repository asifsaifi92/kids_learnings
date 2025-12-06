
import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/core/widgets/parental_gate.dart';
import 'package:kids/features/challenges/presentation/widgets/todays_goals_card.dart';
import 'package:kids/features/parent_settings/presentation/pages/parent_settings_page.dart';
import 'package:kids/features/parent_settings/presentation/provider/profile_provider.dart';
import 'package:kids/features/rewards/presentation/pages/trophy_room_page.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/achievement_unlocked_popup.dart';
import 'package:kids/features/rewards/presentation/widgets/daily_login_popup.dart';
import 'package:provider/provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextToSpeechService _tts = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _tts.init();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoShowDailyReward();
      _listenForAchievements();
      // Removed greeting as requested
    });
  }

  void _listenForAchievements() {
    final achProvider = context.read<AchievementsProvider>();
    achProvider.addListener(() {
      if (achProvider.latestUnlocked != null && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AchievementUnlockedPopup(achievement: achProvider.latestUnlocked!),
        );
      }
    });
  }

  void _autoShowDailyReward() {
    final rewardsProvider = context.read<RewardsProvider>();
    if (rewardsProvider.canClaimDailyReward) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DailyLoginPopup(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CartoonBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: const [
                  _TopHeader(),
                  SizedBox(height: 10),
                  CartoonMascot(size: 150),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: FeatureCarousel(),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Row 1: Profile (Left) and Stars (Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfileBadge(context),
              const StarCounter(),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, TrophyRoomPage.routeName),
                child: _buildHeaderIcon(Icons.emoji_events, Colors.amber),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const DailyLoginPopup(),
                ),
                child: _buildHeaderIcon(Icons.calendar_month, Colors.lightBlue),
              ),
              const SizedBox(width: 12),
              
              // SETTINGS WITH PARENTAL GATE
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ParentalGate(
                      onSuccess: () {
                        Navigator.pushNamed(context, ParentSettingsPage.routeName);
                      },
                    ),
                  );
                },
                child: const SettingsButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBadge(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, _) {
        final Map<String, String> avatarEmojis = {
          'boy': '👦', 'girl': '👧', 'bear': '🐻', 
          'cat': '🐱', 'robot': '🤖', 'dino': '🦖',
        };
        final String avatar = avatarEmojis[profile.avatarId] ?? '🙂';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(avatar, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderIcon(IconData icon, Color color, {bool isPremium = false}) {
    return Container(
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
        border: isPremium ? Border.all(color: Colors.amber, width: 2) : null,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

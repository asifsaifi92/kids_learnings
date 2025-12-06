
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:provider/provider.dart';

class AchievementUnlockedPopup extends StatefulWidget {
  final Achievement achievement;

  const AchievementUnlockedPopup({super.key, required this.achievement});

  @override
  State<AchievementUnlockedPopup> createState() => _AchievementUnlockedPopupState();
}

class _AchievementUnlockedPopupState extends State<AchievementUnlockedPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final TextToSpeechService _ttsService = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _ttsService.init();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    // Play fanfare sound and announce achievement
    SoundManager().playSuccess(); // Assuming success sound is a fanfare
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _ttsService.speak("Achievement unlocked! ${widget.achievement.title}!");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(context),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        // Main Card
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 65 + 16,
            right: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 10),
                blurRadius: 20,
              ),
              BoxShadow(
                color: Colors.lightBlue.withOpacity(0.2),
                offset: const Offset(0, -5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Colors.lightBlue.shade200, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Achievement Unlocked!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.lightBlue,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.achievement.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.achievement.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AchievementsProvider>(context, listen: false).clearLatestUnlocked();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Awesome!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Floating Badge Icon
        Positioned(
          top: -40,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 55,
            child: CircleAvatar(
              backgroundColor: Colors.lightBlue.shade100,
              radius: 50,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Image.asset(
                  widget.achievement.iconAsset,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.star,
                      size: 80,
                      color: Colors.blue,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

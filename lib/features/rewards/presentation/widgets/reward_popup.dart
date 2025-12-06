// lib/features/rewards/presentation/widgets/reward_popup.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';

class RewardPopup extends StatefulWidget {
  const RewardPopup({super.key});

  @override
  State<RewardPopup> createState() => _RewardPopupState();
}

class _RewardPopupState extends State<RewardPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final TextToSpeechService _ttsService = TextToSpeechService();

  @override
  void initState() {
    super.initState();

    // 1. Initialize Animation Controller for the "Bounce In" effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // 2. Play Sound and Voice
    _playCelebration();
  }

  void _playCelebration() async {
    // Initialize TTS
    await _ttsService.init();

    // Play Success Sound Effect
    SoundManager().playSuccess();

    // Delay speaking slightly so the SFX can be heard
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _ttsService.speak("Great Job! You earned a star!");
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
            top: 65 + 16, // Padding for the avatar + extra space
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
              // Inner glow
              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                offset: const Offset(0, -5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Colors.amber.shade200, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              const Text(
                'Great Job!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepOrange,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              // Message
              const Text(
                'You earned a new star for your collection!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
        
        // Bouncing Star Animation at the top
        Positioned(
          top: -40, // Pull it up to overlap the top edge
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 55,
            child: CircleAvatar(
              backgroundColor: Colors.amber.shade100,
              radius: 50,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Lottie.asset(
                  'assets/animations/star_pop.json',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.star,
                      size: 80,
                      color: Colors.amber,
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

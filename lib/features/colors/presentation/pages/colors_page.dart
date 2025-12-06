// lib/features/colors/presentation/pages/colors_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:provider/provider.dart';
import '../provider/colors_provider.dart';
import 'package:kids/features/colors/presentation/widgets/color_bubble.dart' as cbw;
import 'package:kids/features/colors/domain/entities/color_item.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/reward_popup.dart'; // Changed to absolute import

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});
  static const routeName = '/colors';

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  bool _gameActive = false;
  String _gameMessage = '';
  ColorItem? _target;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ColorsProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  void _startGame() {
    final prov = Provider.of<ColorsProvider>(context, listen: false);
    if (prov.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Colors are still loading...')));
      return;
    }
    final rnd = Random();
    final selected = prov.items[rnd.nextInt(prov.items.length)];
    _target = selected;
    setState(() {
      _gameActive = true;
      _gameMessage = 'Tap the ${_target!.displayText} color!';
    });
    prov.speak(_target!);
  }

  void _onColorTap(ColorItem item) {
    final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    final challengeProvider = Provider.of<DailyChallengeProvider>(context, listen: false);
    final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);

    colorsProvider.speak(item);

    if (!learningProvider.completedColors.contains(item.name)) {
      challengeProvider.updateProgress(ChallengeType.LearnColors);
    }
    learningProvider.markColorAsLearned(item.name);

    final text = (item.ttsText).trim().isNotEmpty ? item.ttsText : item.displayText;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speaking: $text'), duration: const Duration(milliseconds: 700)));

    if (_gameActive) {
      if (_target != null && item.id == _target!.id) {
        setState(() {
          _gameActive = false;
          _gameMessage = 'Yay! You found ${_target!.displayText}!';
        });
        rewardsProvider.awardStar();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const RewardPopup();
          },
        );
      } else {
        setState(() {
          _gameMessage = 'Not ${_target?.displayText ?? 'that one'}. Try again!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorsProvider = Provider.of<ColorsProvider>(context);
    final learningProvider = Provider.of<LearningProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: colorsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Controls Area
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play: Find Color'),
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: Colors.indigo.shade50,
                        foregroundColor: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                
                // Game Instruction Banner
                if (_gameActive)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber.shade800, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flag, color: Colors.deepOrange, size: 30),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            _gameMessage,
                            style: TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Success/Failure Message
                if (!_gameActive && _gameMessage.isNotEmpty)
                  Container(
                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: _gameMessage.startsWith('Yay') ? Colors.green.shade100 : Colors.red.shade100,
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(
                         color: _gameMessage.startsWith('Yay') ? Colors.green : Colors.red,
                         width: 1
                       ),
                     ),
                     child: Text(
                       _gameMessage, 
                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                       textAlign: TextAlign.center,
                     ),
                  ),

                // Color Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: colorsProvider.items
                        .map((c) => GestureDetector(
                              onTap: () => _onColorTap(c),
                              child: cbw.ColorBubble(
                                label: c.displayText,
                                colorHex: c.colorHex,
                                isLearned: learningProvider.completedColors.contains(c.name),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

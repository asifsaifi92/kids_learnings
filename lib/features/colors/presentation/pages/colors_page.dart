// lib/features/colors/presentation/pages/colors_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:provider/provider.dart';
import '../provider/colors_provider.dart';
import 'package:kids/features/colors/presentation/widgets/color_bubble.dart' as cbw;
import 'package:kids/features/colors/domain/entities/color_item.dart';
import '../../../rewards/presentation/provider/rewards_provider.dart';
import '../../../rewards/presentation/widgets/reward_popup.dart';

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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: _startGame, child: const Text('Play: Find Color')),
                      if (_gameActive) Row(children: [
                        const Icon(Icons.flag, color: Colors.black54, size: 18),
                        const SizedBox(width: 8),
                        Text(_gameMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
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
                if (!_gameActive && _gameMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_gameMessage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
    );
  }
}

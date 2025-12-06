
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/reward_popup.dart';
import 'package:provider/provider.dart';

class SpellingPage extends StatefulWidget {
  static const routeName = '/spelling';
  const SpellingPage({super.key});

  @override
  State<SpellingPage> createState() => _SpellingPageState();
}

class _SpellingPageState extends State<SpellingPage> {
  final TextToSpeechService _tts = TextToSpeechService();
  int _currentIndex = 0;
  
  // Game State
  late List<String> _shuffledLetters;
  final List<String?> _placedLetters = [];
  bool _isCompleted = false;

  // Word Data (Reusing existing assets)
  final List<SpellingWord> _words = [
    SpellingWord('CAT', 'assets/images/animals/cat.png'), // Assuming you have this or similar
    SpellingWord('DOG', 'assets/images/animals/dog.png'),
    SpellingWord('LION', 'assets/images/animals/lion.png'),
    SpellingWord('APPLE', 'assets/images/fruits/apple.png'),
    SpellingWord('FISH', 'assets/images/animals/fish.png'),
    SpellingWord('KIWI', 'assets/images/fruits/kiwi.png'),
  ];

  // Fallback if assets missing
  SpellingWord get _currentWord => _words[_currentIndex];

  @override
  void initState() {
    super.initState();
    _tts.init();
    _initLevel();
  }

  void _initLevel() {
    _isCompleted = false;
    _placedLetters.clear();
    _placedLetters.addAll(List.filled(_currentWord.word.length, null));
    
    // Prepare shuffled letters (Target word + 2 random extras for difficulty)
    final targetLetters = _currentWord.word.split('');
    // Add distraction letters
    final extras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')..shuffle();
    targetLetters.addAll(extras.take(2)); 
    targetLetters.shuffle();
    
    setState(() {
      _shuffledLetters = targetLetters;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _tts.speak("Spell the word ${_currentWord.word}");
    });
  }

  void _onLetterDropped(String letter, int index) {
    // Check if correct letter for this slot
    final correctChar = _currentWord.word[index];
    
    if (letter == correctChar) {
      // Correct!
      setState(() {
        _placedLetters[index] = letter;
      });
      SoundManager().playPop(); // Ding sound
      
      // Check win condition
      if (!_placedLetters.contains(null)) {
        _handleWin();
      }
    } else {
      // Wrong!
      SoundManager().playClick(); // Error sound substitute
      // Optional: Visual shake or feedback
    }
  }

  void _handleWin() {
    setState(() => _isCompleted = true);
    SoundManager().playSuccess();
    _tts.speak("Correct! ${_currentWord.word}!");
    
    Provider.of<RewardsProvider>(context, listen: false).awardStar();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RewardPopup(),
    ).then((_) {
      if (_currentIndex < _words.length - 1) {
        setState(() => _currentIndex++);
        _initLevel();
      } else {
        Navigator.pop(context); // Finish all words
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Builder'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 1. Image Area
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Image.asset(
                    _currentWord.imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (c, o, s) => const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // 2. Drop Zones (The Word) - Changed Row to Wrap for safety
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(_currentWord.word.length, (index) {
                      final letter = _placedLetters[index];
                      return DragTarget<String>(
                        onWillAccept: (data) => letter == null, // Only accept if empty
                        onAccept: (data) => _onLetterDropped(data, index),
                        builder: (context, candidates, rejects) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: letter != null ? Colors.teal.shade100 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: candidates.isNotEmpty ? Colors.teal : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                letter ?? '',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),

            // 3. Letter Bank (Draggables)
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _shuffledLetters.map((char) {
                    return Draggable<String>(
                      data: char,
                      feedback: _buildLetterTile(char, scaling: 1.2),
                      childWhenDragging: Opacity(opacity: 0.3, child: _buildLetterTile(char)),
                      child: _buildLetterTile(char),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterTile(String char, {double scaling = 1.0}) {
    return Transform.scale(
      scale: scaling,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.teal.shade200, width: 2),
        ),
        child: Center(
          child: Text(
            char,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}

class SpellingWord {
  final String word;
  final String imageAsset;
  SpellingWord(this.word, this.imageAsset);
}

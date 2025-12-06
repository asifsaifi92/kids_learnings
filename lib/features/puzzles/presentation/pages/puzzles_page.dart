
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class PuzzlesPage extends StatefulWidget {
  const PuzzlesPage({super.key});
  static const routeName = '/puzzles';

  @override
  State<PuzzlesPage> createState() => _PuzzlesPageState();
}

class _PuzzlesPageState extends State<PuzzlesPage> {
  // Game Configuration
  final int _gridRows = 4;
  final int _gridCols = 3;
  late List<MemoryCardModel> _cards;
  bool _isProcessing = false; // To prevent tapping while checking match
  int _score = 0;
  int _moves = 0;
  
  // TTS Service
  final _ttsService = TextToSpeechService();

  // Asset pools to choose from
  final List<String> _allImages = [
    'assets/images/animals/lion.png',
    'assets/images/animals/elephant.png',
    'assets/images/animals/giraffe.png',
    'assets/images/animals/monkey.png',
    'assets/images/animals/panda.png',
    'assets/images/fruits/apple.png',
    'assets/images/fruits/banana.png',
    'assets/images/fruits/orange.png',
    'assets/images/fruits/strawberry.png',
    'assets/images/fruits/grapes.png',
  ];

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _resetGame();
  }
  
  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  void _resetGame() {
    // 1. Calculate how many pairs we need
    int totalCards = _gridRows * _gridCols;
    int numberOfPairs = totalCards ~/ 2;

    // 2. Shuffle available images and pick the needed amount
    List<String> gameImages = List.from(_allImages)..shuffle();
    gameImages = gameImages.take(numberOfPairs).toList();

    // 3. Create pairs
    List<MemoryCardModel> deck = [];
    for (var img in gameImages) {
      deck.add(MemoryCardModel(imagePath: img));
      deck.add(MemoryCardModel(imagePath: img)); // The pair
    }

    // 4. Shuffle the deck
    deck.shuffle();

    setState(() {
      _cards = deck;
      _score = 0;
      _moves = 0;
      _isProcessing = false;
    });
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cards[index].isFaceUp || _cards[index].isMatched) {
      return;
    }

    setState(() {
      _cards[index].isFaceUp = true;
      _moves++;
    });

    // Check for potential match
    List<int> faceUpIndices = [];
    for (int i = 0; i < _cards.length; i++) {
      if (_cards[i].isFaceUp && !_cards[i].isMatched) {
        faceUpIndices.add(i);
      }
    }

    if (faceUpIndices.length == 2) {
      _checkForMatch(faceUpIndices[0], faceUpIndices[1]);
    }
  }

  void _checkForMatch(int index1, int index2) {
    _isProcessing = true;
    final card1 = _cards[index1];
    final card2 = _cards[index2];

    if (card1.imagePath == card2.imagePath) {
      // Match found!
      setState(() {
        card1.isMatched = true;
        card2.isMatched = true;
        _score += 10;
        _isProcessing = false;
      });
      
      // Play Audio Feedback
      _announceMatch(card1.imagePath);
      
      _checkWinCondition();
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            card1.isFaceUp = false;
            card2.isFaceUp = false;
            _isProcessing = false;
          });
        }
      });
    }
  }

  void _announceMatch(String imagePath) {
    // Extract name from path (e.g., 'assets/images/animals/lion.png' -> 'lion')
    try {
      final filename = imagePath.split('/').last; // lion.png
      final name = filename.split('.').first; // lion
      
      // Speak!
      _ttsService.speak("You found the $name!");
    } catch (e) {
      // ignore: avoid_print
      print("Error parsing name for TTS: $e");
    }
  }

  void _checkWinCondition() {
    bool allMatched = _cards.every((card) => card.isMatched);
    if (allMatched) {
      // Award stars using Provider
      final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);
      rewardsProvider.awardStar();
      
      // Achievement: Puzzle Master
      context.read<AchievementsProvider>().incrementProgress('puzzle_master');
      
      // Celebration Audio
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _ttsService.speak("Great job! You solved the puzzle!");
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Puzzle Solved! 🎉', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 60),
              const SizedBox(height: 16),
              Text('You found all pairs in $_moves moves!'),
              const SizedBox(height: 8),
              const Text('You earned a star!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Puzzle'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          )
        ],
      ),
      body: Column(
        children: [
          // Score Board
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreCard('Moves', '$_moves', Colors.blue),
                _buildScoreCard('Score', '$_score', Colors.green),
              ],
            ),
          ),
          
          // Game Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridCols,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return _buildCard(_cards[index], index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCard(MemoryCardModel card, int index) {
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isFaceUp || card.isMatched ? Colors.white : Colors.orange.shade300,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            )
          ],
          border: card.isMatched 
              ? Border.all(color: Colors.green, width: 3) 
              : Border.all(color: Colors.white, width: 2),
        ),
        child: card.isFaceUp || card.isMatched
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(card.imagePath, fit: BoxFit.contain),
              )
            : const Icon(Icons.question_mark, color: Colors.white, size: 40),
      ),
    );
  }
}

class MemoryCardModel {
  final String imagePath;
  bool isFaceUp;
  bool isMatched;

  MemoryCardModel({
    required this.imagePath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

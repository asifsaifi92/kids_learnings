// lib/features/quiz/presentation/pages/quiz_page.dart

import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/quiz/presentation/provider/quiz_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  static const routeName = '/quiz';

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _ttsService = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Time!'),
        backgroundColor: Colors.amber,
      ),
      body: quizProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizProvider.quizCompleted
              ? _buildCompletionScreen(context)
              : _buildQuestionScreen(context),
    );
  }

  Widget _buildQuestionScreen(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final question = provider.currentQuestion;

    if (question == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not enough items to create a quiz!', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Go Back')),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question.questionText,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, size: 36, color: Colors.blueAccent),
                onPressed: () => _ttsService.speak(question.questionText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (question.questionVisual != null)
            Center(
              child: SizedBox(
                height: 120,
                child: question.questionVisual!,
              ),
            ),
          const SizedBox(height: 40),
          ...question.options.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      onPressed: () => provider.answerQuestion(option),
                      child: Text(option),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.orangeAccent),
                    onPressed: () => _ttsService.speak(option),
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final rewardsProvider = context.read<RewardsProvider>();
    final challengeProvider = context.read<DailyChallengeProvider>();

    // Update challenge progress and award stars
    WidgetsBinding.instance.addPostFrameCallback((_) {
      challengeProvider.updateProgress(ChallengeType.CompleteQuizzes);
      for (int i = 0; i < provider.score; i++) {
        rewardsProvider.awardStar();
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'You scored: ${provider.score} / ${provider.questions.length}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          if (provider.score > 0)
            Text(
              'You earned ${provider.score} stars!',
              style: const TextStyle(fontSize: 20, color: Colors.amber),
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Go back to the selection screen
            },
            child: const Text('Play Another Quiz!'),
          ),
        ],
      ),
    );
  }
}

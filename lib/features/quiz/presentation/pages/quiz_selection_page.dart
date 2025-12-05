// lib/features/quiz/presentation/pages/quiz_selection_page.dart

import 'package:flutter/material.dart';
import 'package:kids/features/quiz/presentation/pages/quiz_page.dart';
import 'package:kids/features/quiz/presentation/provider/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuizSelectionPage extends StatefulWidget {
  const QuizSelectionPage({super.key});
  static const routeName = '/quiz-selection';

  @override
  State<QuizSelectionPage> createState() => _QuizSelectionPageState();
}

class _QuizSelectionPageState extends State<QuizSelectionPage> {
  bool _isLoading = false;

  Future<void> _startQuiz(QuizType quizType) async {
    setState(() {
      _isLoading = true;
    });

    await context.read<QuizProvider>().startQuiz(context, quizType);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(QuizPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Quiz'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Getting the quiz ready...'),
                ],
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(24.0),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildQuizCategoryCard(context, 'Alphabet Quiz', Icons.abc, Colors.red, QuizType.Alphabet),
                _buildQuizCategoryCard(context, 'Number Quiz', Icons.format_list_numbered, Colors.blue, QuizType.Numbers),
                _buildQuizCategoryCard(context, 'Color Quiz', Icons.palette, Colors.purple, QuizType.Colors),
                _buildQuizCategoryCard(context, 'Shape Quiz', Icons.category, Colors.orange, QuizType.Shapes),
                _buildQuizCategoryCard(context, 'Alphabet Sequence', Icons.arrow_forward, Colors.green, QuizType.AlphabetSequence),
                _buildQuizCategoryCard(context, 'Number Sequence', Icons.arrow_forward, Colors.teal, QuizType.NumberSequence),
              ],
            ),
    );
  }

  Widget _buildQuizCategoryCard(BuildContext context, String title, IconData icon, Color color, QuizType quizType) {
    return GestureDetector(
      onTap: () => _startQuiz(quizType),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

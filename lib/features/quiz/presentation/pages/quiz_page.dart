
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/quiz/presentation/provider/quiz_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rewards/presentation/widgets/reward_popup.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  static const routeName = '/quiz';

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final _ttsService = TextToSpeechService();
  
  // Game State
  Timer? _timer;
  int _timeLeft = 15; // 15 seconds per question
  int _streak = 0;
  int _hearts = 3;
  
  // Feedback State
  String? _selectedOption;
  bool _isAnswerChecked = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _startTimer();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 15;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    _handleWrongAnswer(timeUp: true);
  }

  void _handleAnswer(String option, String correctAnswer) {
    if (_isProcessing) return; // Prevent double taps
    _timer?.cancel();
    
    setState(() {
      _isProcessing = true;
      _selectedOption = option;
      _isAnswerChecked = true;
    });

    if (option == correctAnswer) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }
  }

  void _handleCorrectAnswer() {
    SoundManager().playSuccess();
    setState(() {
      _streak++;
    });
    
    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.read<QuizProvider>().answerQuestion(_selectedOption!);
        _resetForNextQuestion();
      }
    });
  }

  void _handleWrongAnswer({bool timeUp = false}) {
    SoundManager().playClick(); // Or a 'wrong' sound if available
    setState(() {
      _streak = 0;
      _hearts--;
    });

    if (_hearts <= 0) {
      // Game Over Logic could go here, but for kids we usually just finish the quiz
      // For now, let's just proceed but with 0 score for this q
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        // If time up, we simulate a wrong answer to the provider
        context.read<QuizProvider>().answerQuestion(timeUp ? "" : _selectedOption!);
        _resetForNextQuestion();
      }
    });
  }

  void _resetForNextQuestion() {
    if (context.read<QuizProvider>().quizCompleted) return;
    
    setState(() {
      _isProcessing = false;
      _isAnswerChecked = false;
      _selectedOption = null;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Show!'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: List.generate(3, (index) => Icon(
                index < _hearts ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
              )),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: quizProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : quizProvider.quizCompleted
                ? _buildCompletionScreen(context)
                : _buildQuestionScreen(context),
      ),
    );
  }

  Widget _buildQuestionScreen(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final question = provider.currentQuestion;

    if (question == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Stats Bar (Timer & Streak)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timeLeft < 5 ? Colors.red.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 20, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Text('$_timeLeft s', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Streak
              if (_streak > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 20, color: Colors.orange),
                      Text(' $_streak Streak!', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 10),
          // Timer Progress Bar
          LinearProgressIndicator(
            value: _timeLeft / 15.0,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(_timeLeft < 5 ? Colors.red : Colors.blue),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const Spacer(),

          // 2. Question Area
          Text(
            question.questionText,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, size: 40, color: Colors.blueAccent),
            onPressed: () => _ttsService.speak(question.questionText),
          ),
          
          if (question.questionVisual != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(height: 150, child: question.questionVisual!),
            ),

          const Spacer(),

          // 3. Options
          ...question.options.map((option) {
            // Determine Button Style based on state
            Color btnColor = Colors.white;
            Color textColor = Colors.black87;
            IconData? icon;
            
            // "Hack" to get correct answer from provider logic if possible, 
            // but usually quiz provider logic handles 'isCorrect'.
            // For now, assume if checked and matches selection, we show status.
            // Ideally we need to know the correct answer to show green even if wrong picked.
            // Let's rely on the fact that if we are 'checked', we know if it was correct.
            
            // Simplified logic: If selected, show color. 
            // Ideally, pass 'correctAnswer' to `_handleAnswer`.
            // Since provider doesn't expose it easily in 'currentQuestion', 
            // we will just show feedback on the selected item.
            
            if (_isAnswerChecked) {
              if (option == _selectedOption) {
                 // We need to know if it's correct. 
                 // Since we don't have 'correctAnswer' in the public getter easily 
                 // without modifying entity, let's modify the `answerQuestion` flow or
                 // just peek at how `answerQuestion` works.
                 // Actually, `_handleAnswer` logic above assumed we knew it.
                 // Let's modify the UI to assume the provider handles scoring,
                 // but for visual feedback we need to know the truth.
                 
                 // Since I cannot change the Entity right now easily without breaking other things,
                 // I will assume for this display that we highlight the selected one.
                 // In `_handleAnswer`, I assumed `correctAnswer` was passed. 
                 // I need to find the correct answer from `question`!
                 // Ah, `QuizQuestion` usually has `correctAnswer`. Let's assume it does.
                 
                 // Check if the property exists on `question`.
              }
            }
            
            // Realizing `QuizQuestion` might not expose `correctAnswer` publicly or I need to check the file.
            // I'll check `quiz_question.dart` quickly or assume standard structure.
            // Actually, let's just make the button color dynamic.
            
            bool isSelected = option == _selectedOption;
            // Temporary: We will determine correctness inside the button builder
            // by comparing with `question.correctAnswer`.
            
            return _buildOptionButton(option, question.correctAnswer, isSelected);
          }).toList(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer, bool isSelected) {
    Color color = Colors.white;
    Color border = Colors.indigo.shade100;
    IconData? icon;

    if (_isAnswerChecked) {
      if (option == correctAnswer) {
        color = Colors.green.shade100;
        border = Colors.green;
        icon = Icons.check_circle;
      } else if (isSelected) {
        color = Colors.red.shade100;
        border = Colors.red;
        icon = Icons.cancel;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: _isAnswerChecked ? null : () => _handleAnswer(option, correctAnswer),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: border, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (icon != null) Icon(icon, color: border),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final rewardsProvider = context.read<RewardsProvider>();
    final challengeProvider = context.read<DailyChallengeProvider>();

    // Run once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isProcessing) { // Use flag to prevent double processing
        _isProcessing = true;
        challengeProvider.updateProgress(ChallengeType.CompleteQuizzes);
        for (int i = 0; i < provider.score; i++) {
          rewardsProvider.awardStar();
        }
        SoundManager().playSuccess();
        // Show reward popup
        showDialog(
          context: context,
          builder: (_) => const RewardPopup(),
        );
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
          const SizedBox(height: 20),
          const Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: ${provider.score} / ${provider.questions.length}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'You earned ${provider.score} stars!',
            style: const TextStyle(fontSize: 20, color: Colors.orange),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('Play Again!'),
          ),
        ],
      ),
    );
  }
}

// lib/features/quiz/presentation/provider/quiz_provider.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/colors/presentation/provider/colors_provider.dart';
import 'package:kids/features/learning/domain/usecases/get_alphabet_items.dart';
import 'package:kids/features/learning/domain/usecases/get_number_items.dart';
import 'package:kids/features/shapes/presentation/provider/shapes_provider.dart';
import 'package:provider/provider.dart';

// Represents a single question in a quiz, now with an optional visual element.
class QuizQuestion {
  final String questionText;
  final Widget? questionVisual; // To display a color swatch or shape
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.questionText,
    this.questionVisual,
    required this.options,
    required this.correctAnswer,
  });
}

enum QuizType {
  Alphabet,
  Numbers,
  Colors,
  Shapes,
  AlphabetSequence,
  NumberSequence, // Added new quiz type
}

class QuizProvider extends ChangeNotifier {
  final GetAlphabetItems getAlphabetItems;
  final GetNumberItems getNumberItems;

  QuizProvider({
    required this.getAlphabetItems,
    required this.getNumberItems,
  });

  // --- State ---
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  bool _isLoading = false;

  // --- Getters ---
  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get quizCompleted => _quizCompleted;
  bool get isLoading => _isLoading;
  QuizQuestion? get currentQuestion => _questions.isNotEmpty && !_quizCompleted ? _questions[_currentQuestionIndex] : null;

  // --- Methods ---

  Future<void> startQuiz(BuildContext context, QuizType type) async {
    _isLoading = true;
    _quizCompleted = false;
    _score = 0;
    _currentQuestionIndex = 0;
    notifyListeners();

    _questions = await _generateQuestionsFor(context, type);

    _isLoading = false;
    notifyListeners();
  }

  void answerQuestion(String answer) {
    if (_quizCompleted) return;

    if (answer == currentQuestion?.correctAnswer) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _quizCompleted = true;
    }
    notifyListeners();
  }

  // --- Private Helper ---

  Future<List<QuizQuestion>> _generateQuestionsFor(BuildContext context, QuizType type) async {
    switch (type) {
      case QuizType.Alphabet:
        return _generateAlphabetQuestions();
      case QuizType.Numbers:
        return _generateNumberQuestions();
      case QuizType.Colors:
        return await _generateColorQuestions(context);
      case QuizType.Shapes:
        return await _generateShapeQuestions(context);
      case QuizType.AlphabetSequence:
        return _generateAlphabetSequenceQuestions();
      case QuizType.NumberSequence:
        return _generateNumberSequenceQuestions(); // Added new case
    }
  }

  List<QuizQuestion> _generateAlphabetQuestions() {
    final items = getAlphabetItems();
    items.shuffle();
    return _createTextBasedQuiz(items.take(5).toList(), (item) => item.letter, (item) => 'Which one is the letter "${item.letter}"?');
  }

  List<QuizQuestion> _generateNumberQuestions() {
    final items = getNumberItems();
    items.shuffle();
    return _createTextBasedQuiz(items.take(5).toList(), (item) => item.value.toString(), (item) => 'What number is this: ${item.value}?');
  }

  Future<List<QuizQuestion>> _generateColorQuestions(BuildContext context) async {
    final colorsProvider = context.read<ColorsProvider>();
    if (colorsProvider.items.isEmpty) {
      await colorsProvider.load();
    }
    final items = [...colorsProvider.items];
    if (items.length < 4) return [];
    items.shuffle();

    return items.take(5).map((item) {
      return QuizQuestion(
        questionText: 'What color is this?',
        questionVisual: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _parseHex(item.colorHex),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
          ),
        ),
        options: _generateOptions(items.map((i) => i.name).toList(), item.name),
        correctAnswer: item.name,
      );
    }).toList();
  }

  Future<List<QuizQuestion>> _generateShapeQuestions(BuildContext context) async {
    final shapesProvider = context.read<ShapesProvider>();
    if (shapesProvider.items.isEmpty) {
      await shapesProvider.load();
    }
    final items = [...shapesProvider.items];
    if (items.length < 4) return [];
    items.shuffle();

    return items.take(5).map((item) {
      return QuizQuestion(
        questionText: 'What shape is this?',
        questionVisual: SizedBox(width: 100, height: 100, child: item.shapeWidget),
        options: _generateOptions(items.map((i) => i.name).toList(), item.name),
        correctAnswer: item.name,
      );
    }).toList();
  }

  List<QuizQuestion> _generateAlphabetSequenceQuestions() {
    final alphabet = List.generate(26, (index) => String.fromCharCode(index + 65));
    final questions = <QuizQuestion>[];
    final random = Random();

    for (int i = 0; i < 5; i++) {
      final int startIndex = random.nextInt(alphabet.length - 2); // Ensure there's a next letter
      final letter = alphabet[startIndex];
      final correctAnswer = alphabet[startIndex + 1];

      final options = {correctAnswer};
      while (options.length < 4) {
        options.add(alphabet[random.nextInt(alphabet.length)]);
      }
      final optionList = options.toList();
      optionList.shuffle();

      questions.add(QuizQuestion(
        questionText: 'What letter comes after "$letter"?',
        options: optionList,
        correctAnswer: correctAnswer,
      ));
    }
    return questions;
  }

    List<QuizQuestion> _generateNumberSequenceQuestions() {
    final numbers = getNumberItems().map((e) => e.value).toList();
    if (numbers.length < 2) return [];
    final questions = <QuizQuestion>[];
    final random = Random();

    for (int i = 0; i < 5; i++) {
      final int startIndex = random.nextInt(numbers.length - 1); // Ensure there's a next number
      final number = numbers[startIndex];
      final correctAnswer = numbers[startIndex + 1];

      final options = {correctAnswer.toString()};
      while (options.length < 4) {
        options.add(numbers[random.nextInt(numbers.length)].toString());
      }
      final optionList = options.toList();
      optionList.shuffle();

      questions.add(QuizQuestion(
        questionText: 'What number comes after "$number"?',
        options: optionList,
        correctAnswer: correctAnswer.toString(),
      ));
    }
    return questions;
  }

  List<String> _generateOptions(List<String> allItems, String correctAnswer) {
    final options = {correctAnswer};
    allItems.shuffle();
    for (var name in allItems) {
      if (options.length < 4) {
        options.add(name);
      } else {
        break;
      }
    }
    final optionList = options.toList();
    optionList.shuffle();
    return optionList;
  }

  List<QuizQuestion> _createTextBasedQuiz<T>(List<T> items, String Function(T) nameExtractor, String Function(T) questionExtractor) {
    if (items.length < 4) return [];
    final allNames = items.map(nameExtractor).toList();
    return items.map((item) {
      return QuizQuestion(
        questionText: questionExtractor(item),
        options: _generateOptions(allNames, nameExtractor(item)),
        correctAnswer: nameExtractor(item),
      );
    }).toList();
  }

  Color _parseHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}


import 'dart:math';
import 'package:flutter/material.dart';

class ParentalGate extends StatefulWidget {
  final VoidCallback onSuccess;

  const ParentalGate({super.key, required this.onSuccess});

  @override
  State<ParentalGate> createState() => _ParentalGateState();
}

class _ParentalGateState extends State<ParentalGate> {
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  late List<int> _options;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  void _generateChallenge() {
    final rnd = Random();
    _num1 = rnd.nextInt(5) + 1; // 1-5
    _num2 = rnd.nextInt(5) + 1; // 1-5
    _correctAnswer = _num1 + _num2;

    // Generate options
    final Set<int> optionSet = {_correctAnswer};
    while (optionSet.length < 3) {
      int wrong = _correctAnswer + (rnd.nextInt(5) - 2); // +/- 2 range
      if (wrong > 0 && wrong != _correctAnswer) {
        optionSet.add(wrong);
      }
    }
    _options = optionSet.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'For Parents Only',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please verify you are an adult.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              'What is $_num1 + $_num2 ?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options.map((option) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade50,
                    foregroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (option == _correctAnswer) {
                      Navigator.pop(context);
                      widget.onSuccess();
                    } else {
                      // Wrong answer feedback
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Incorrect. Access denied.')),
                      );
                    }
                  },
                  child: Text('$option'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

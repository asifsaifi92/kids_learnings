import 'package:flutter/material.dart';

class AlphabetScreen extends StatelessWidget {
  static const routeName = '/alphabet';

  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Alphabets'),
      ),
      body: const Center(
        child: Text('Alphabet Screen'),
      ),
    );
  }
}
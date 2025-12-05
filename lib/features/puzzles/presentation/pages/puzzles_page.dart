
import 'package:flutter/material.dart';

class PuzzlesPage extends StatelessWidget {
  const PuzzlesPage({super.key});
  static const routeName = '/puzzles';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzles'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Puzzles Page - Coming Soon!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

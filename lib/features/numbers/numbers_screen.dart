import 'package:flutter/material.dart';

class NumbersScreen extends StatelessWidget {
  static const routeName = '/numbers';

  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Numbers'),
      ),
      body: const Center(
        child: Text('Numbers Screen'),
      ),
    );
  }
}
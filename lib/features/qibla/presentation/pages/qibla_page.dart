
import 'package:flutter/material.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});
  static const routeName = '/qibla';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Finder'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Qibla Finder Page - Coming Soon!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

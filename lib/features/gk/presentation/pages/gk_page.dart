
import 'package:flutter/material.dart';

class GKPage extends StatelessWidget {
  const GKPage({super.key});
  static const routeName = '/gk';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Knowledge'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'General Knowledge Page - Coming Soon!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

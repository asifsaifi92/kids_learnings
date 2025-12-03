// lib/features/stories/presentation/pages/stories_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/stories_provider.dart';
import '../widgets/story_card.dart';
import 'story_reader_page.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});
  static const routeName = '/stories';

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StoriesProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StoriesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedtime Stories'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade50, Colors.lightBlue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: prov.items.length,
                itemBuilder: (context, index) {
                  final item = prov.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: StoryCard(
                      story: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoryReaderPage(story: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

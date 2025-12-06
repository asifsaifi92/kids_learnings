
import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import '../../data/datasources/gk_data.dart';
import '../../data/models/gk_model.dart';

class GKPage extends StatelessWidget {
  const GKPage({super.key});
  static const routeName = '/gk';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Knowledge'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade100, Colors.white],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: gkTopics.length,
          itemBuilder: (context, index) {
            final topic = gkTopics[index];
            return _GKTopicCard(topic: topic);
          },
        ),
      ),
    );
  }
}

class _GKTopicCard extends StatelessWidget {
  final GKTopic topic;

  const _GKTopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GKTopicDetailPage(topic: topic),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: topic.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: topic.color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(topic.icon, size: 50, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              topic.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class GKTopicDetailPage extends StatefulWidget {
  final GKTopic topic;

  const GKTopicDetailPage({super.key, required this.topic});

  @override
  State<GKTopicDetailPage> createState() => _GKTopicDetailPageState();
}

class _GKTopicDetailPageState extends State<GKTopicDetailPage> {
  final _ttsService = TextToSpeechService();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _pageController.dispose();
    super.dispose();
  }

  void _speak(String text) {
    _ttsService.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        backgroundColor: widget.topic.color,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.topic.items.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = widget.topic.items[index];
                return _buildFlashcard(item, widget.topic.color);
              },
            ),
          ),
          const SizedBox(height: 20),
          // Progress Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.topic.items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? widget.topic.color : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFlashcard(GKItem item, Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: themeColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon Placeholder
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: item.imagePath.isNotEmpty && item.imagePath.startsWith('assets')
                  ? Image.asset(item.imagePath, errorBuilder: (c, o, s) => Icon(Icons.image, size: 80, color: themeColor))
                  : Icon(Icons.auto_stories, size: 100, color: themeColor),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _speak("${item.name}. ${item.description}"),
                    icon: CircleAvatar(
                      radius: 24,
                      backgroundColor: themeColor,
                      child: const Icon(Icons.volume_up, color: Colors.white),
                    ),
                    iconSize: 40,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

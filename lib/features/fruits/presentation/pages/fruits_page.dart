
import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/fruits/data/datasources/fruit_data.dart';
import 'package:kids/features/fruits/data/models/fruit.dart';

class FruitsPage extends StatelessWidget {
  const FruitsPage({super.key});
  static const routeName = '/fruits';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits'),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: fruitList.length,
        itemBuilder: (context, index) {
          final fruit = fruitList[index];
          return FruitGridItem(fruit: fruit);
        },
      ),
    );
  }
}

class FruitGridItem extends StatefulWidget {
  final Fruit fruit;

  const FruitGridItem({super.key, required this.fruit});

  @override
  State<FruitGridItem> createState() => _FruitGridItemState();
}

class _FruitGridItemState extends State<FruitGridItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _ttsService = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  void _speakName() {
    _ttsService.speak(widget.fruit.name);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FruitDetailPage(fruit: widget.fruit),
            ),
          );
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.fruit.imagePath, height: 80),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.fruit.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    onPressed: _speakName,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FruitDetailPage extends StatefulWidget {
  final Fruit fruit;

  const FruitDetailPage({super.key, required this.fruit});

  @override
  State<FruitDetailPage> createState() => _FruitDetailPageState();
}

class _FruitDetailPageState extends State<FruitDetailPage> {
  final _ttsService = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  void _speakName() {
    _ttsService.speak(widget.fruit.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fruit.name),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.fruit.imagePath, height: 200),
            const SizedBox(height: 20),
            Text(
              widget.fruit.name,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.volume_up, size: 50),
              onPressed: _speakName,
            ),
          ],
        ),
      ),
    );
  }
}

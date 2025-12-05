
import 'package:flutter/material.dart';
import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/features/animals/data/datasources/animal_data.dart';
import 'package:kids/features/animals/data/models/animal.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});
  static const routeName = '/animals';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals'),
        backgroundColor: Colors.brown,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: animalList.length,
        itemBuilder: (context, index) {
          final animal = animalList[index];
          return AnimalGridItem(animal: animal);
        },
      ),
    );
  }
}

class AnimalGridItem extends StatefulWidget {
  final Animal animal;

  const AnimalGridItem({super.key, required this.animal});

  @override
  State<AnimalGridItem> createState() => _AnimalGridItemState();
}

class _AnimalGridItemState extends State<AnimalGridItem> with SingleTickerProviderStateMixin {
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
    _ttsService.speak(widget.animal.name);
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
              builder: (context) => AnimalDetailPage(animal: widget.animal),
            ),
          );
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown.shade300,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.animal.imagePath, height: 80),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.animal.name,
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

class AnimalDetailPage extends StatefulWidget {
  final Animal animal;

  const AnimalDetailPage({super.key, required this.animal});

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
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
    _ttsService.speak(widget.animal.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal.name),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.animal.imagePath, height: 200),
            const SizedBox(height: 20),
            Text(
              widget.animal.name,
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

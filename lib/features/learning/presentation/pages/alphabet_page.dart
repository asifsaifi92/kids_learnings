// lib/features/learning/presentation/pages/alphabet_page.dart
import 'package:flutter/material.dart';
import '../../../../core/services/text_to_speech_service.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/alphabet_item.dart';
import '../../domain/usecases/get_alphabet_items.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  static const String routeName = '/alphabet';

  @override
  State<AlphabetPage> createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  late final List<AlphabetItem> _items;
  final TextToSpeechService _tts = sl<TextToSpeechService>();
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _items = sl<GetAlphabetItems>()();
  }

  void _onTileTap(int index, String ttsText) {
    _tts.speak(ttsText);
    setState(() {
      _tappedIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _tappedIndex = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF7B9C), Color(0xFFFF5F6D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFF3E0), // Light cream
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final item = _items[index];
            final isTapped = _tappedIndex == index;
            final scale = isTapped ? 0.9 : 1.0;

            return AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: GestureDetector(
                onTap: () => _onTileTap(index, item.ttsText),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(4, 6),
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.letter,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

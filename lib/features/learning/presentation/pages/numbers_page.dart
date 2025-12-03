// lib/features/learning/presentation/pages/numbers_page.dart
import 'package:flutter/material.dart';
import '../../../../core/services/text_to_speech_service.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/number_item.dart';
import '../../domain/usecases/get_number_items.dart';

class NumbersPage extends StatefulWidget {
  const NumbersPage({super.key});

  static const String routeName = '/numbers';

  @override
  State<NumbersPage> createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  late final List<NumberItem> _items;
  final TextToSpeechService _tts = sl<TextToSpeechService>();
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _items = sl<GetNumberItems>()();
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
        title: const Text('Numbers'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6FD6FF), Color(0xFF4DA6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFE3F2FD), // Soft light blue
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6FD6FF), Color(0xFF4DA6FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(4, 6),
                        color: const Color(0xFF4DA6FF).withOpacity(0.4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.value.toString(),
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

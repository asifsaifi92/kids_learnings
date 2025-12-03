// lib/core/services/text_to_speech_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage("en-IN");
    await _flutterTts.setSpeechRate(0.45); // Kid-friendly slower pace
    await _flutterTts.setPitch(1.0); // Normal pitch
  }

  Future<void> speak(String text) async {
    try {
      // Avoid forcing a stop() before every speak to prevent platform-specific issues.
      // Just call speak; FlutterTts will handle queuing or interrupting as needed.
      // ignore: avoid_print
      print('[TextToSpeechService] speak: "$text"');
      await _flutterTts.speak(text);
    } catch (e) {
      // ignore: avoid_print
      print('[TextToSpeechService] speak error: $e');
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

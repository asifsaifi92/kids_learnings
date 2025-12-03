import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService._internal() {
    _flutterTts = FlutterTts();
    _init();
  }

  static final TextToSpeechService _instance = TextToSpeechService._internal();

  factory TextToSpeechService() => _instance;

  late FlutterTts _flutterTts;

  Future<void> _init() async {
    // You can tweak language & pitch as needed
    await _flutterTts.setLanguage("en-IN");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // slower for kids
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}
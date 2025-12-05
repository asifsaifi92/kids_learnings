// lib/core/services/text_to_speech_service.dart
import 'package:flutter/foundation.dart';
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

  /// Speaks the given [chunks] sequentially. Calls [onChunkStart] with the
  /// index of the chunk before speaking it, and calls [onComplete] when all
  /// chunks have been spoken or when playback is stopped.
  Future<void> speakChunks(
    List<String> chunks, {
    required void Function(int index) onChunkStart,
    required void Function() onComplete,
  }) async {
    if (chunks.isEmpty) {
      onComplete();
      return;
    }

    try {
      for (var i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        onChunkStart(i);
        // ignore: avoid_print
        print('[TextToSpeechService] speak chunk $i: "$chunk"');
        await _flutterTts.speak(chunk);
        // Wait for completion by polling the engine's completion handler.
        // flutter_tts provides setCompletionHandler but it is global; to keep
        // this method self-contained we await a small delay to let the engine
        // finish the chunk. This is a simple fallback; the provider will
        // still update index based on onChunkStart.
        await Future.delayed(const Duration(milliseconds: 200));
      }
      onComplete();
    } catch (e) {
      // ignore: avoid_print
      print('[TextToSpeechService] speakChunks error: $e');
      onComplete();
    }
  }

  /// Speaks the full [text] once and uses the TTS progress callback to report
  /// character offsets. [onCharIndex] receives the start char index of the
  /// current progress; [onComplete] is called when done. If progress handlers
  /// are not available or an error occurs, this will throw and the caller can
  /// fallback to `speakChunks`.
  Future<void> speakWithProgress(
    String text, {
    required void Function(int charIndex) onCharIndex,
    required void Function() onComplete,
  }) async {
    try {
      // Register handlers
      // Use dynamic invocation and a loosely-typed handler to support
      // multiple flutter_tts versions/signatures for the progress callback.
      (_flutterTts as dynamic).setProgressHandler((dynamic a, dynamic b, dynamic c, [dynamic d]) {
        // The handler can have various signatures across versions:
        // - (String utterance, int start, int end)
        // - (String? utterance, int? start, int? end)
        // - (String utterance, int start, int end, String word)
        // We try to extract an integer start index from the args.
        int? startIndex;
        if (b is int) startIndex = b;
        else if (c is int) startIndex = c;
        // Some versions may pass start as String - try parsing
        else if (b is String) startIndex = int.tryParse(b);

        if (startIndex != null && startIndex >= 0) {
          onCharIndex(startIndex);
        }
      });

      (_flutterTts as dynamic).setCompletionHandler(() {
        // Clear handlers to avoid leaks
        try {
          (_flutterTts as dynamic).setProgressHandler(null);
        } catch (_) {}
        try {
          (_flutterTts as dynamic).setCompletionHandler(null);
        } catch (_) {}
        onComplete();
      });

      // Start speaking once
      await _flutterTts.speak(text);
    } catch (e) {
      // ignore: avoid_print
      print('[TextToSpeechService] speakWithProgress error: $e');
      // Try to clear handlers to be safe
      try {
        (_flutterTts as dynamic).setProgressHandler(null);
      } catch (_) {}
      try {
        (_flutterTts as dynamic).setCompletionHandler(null);
      } catch (_) {}
      rethrow;
    }
  }
}

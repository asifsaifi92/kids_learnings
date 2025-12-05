// lib/features/rhymes/presentation/provider/rhymes_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/rhyme_item.dart';
import '../../domain/usecases/get_rhymes.dart';
import '../../../../core/services/text_to_speech_service.dart';

class RhymesProvider extends ChangeNotifier {
  final GetRhymes getRhymes;
  final TextToSpeechService ttsService;

  RhymesProvider({
    required this.getRhymes,
    required this.ttsService,
  });

  Set<String> _completedRhymes = {};
  Set<String> get completedRhymes => _completedRhymes;

  /// Call this during app initialization (or when provider is created) to
  /// load persisted settings and progress.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _replayOnResume = prefs.getBool('rhymes_replay_on_resume') ?? _replayOnResume;
    _completedRhymes = (prefs.getStringList('completed_rhymes') ?? []).toSet();
    notifyListeners();
  }

  List<RhymeItem> _items = [];
  List<RhymeItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getRhymes.call();
    _isLoading = false;
    notifyListeners();
  }

  void speak(String text) {
    ttsService.speak(text);
  }

  // Playback state for per-word highlighting
  int _currentWordIndex = -1;
  int get currentWordIndex => _currentWordIndex;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  // Configurable resume behavior: when true, resume will replay the last
  // active word; when false, resume will continue from the next word.
  bool _replayOnResume = true;
  bool get replayOnResume => _replayOnResume;
  set replayOnResume(bool v) {
    _replayOnResume = v;
    SharedPreferences.getInstance().then((prefs) => prefs.setBool('rhymes_replay_on_resume', v));
    notifyListeners();
  }

  List<String> _chunks = [];
  List<Range> _wordRanges = [];
  int _resumeIndex = 0;

  /// Split text into word chunks while preserving punctuation attached to words.
  List<String> _splitToWords(String text) {
    if (text.trim().isEmpty) return [];
    // Split on whitespace but keep punctuation attached to the word.
    return text.trim().split(RegExp(r"\s+"));
  }

  List<Range> _computeWordRanges(String text, List<String> words) {
    final ranges = <Range>[];
    var index = 0;
    for (var w in words) {
      final start = text.indexOf(w, index);
      if (start == -1) {
        // fallback: approximate by advancing index
        final approxStart = index;
        final approxEnd = approxStart + w.length;
        ranges.add(Range(approxStart, approxEnd));
        index = approxEnd + 1;
      } else {
        ranges.add(Range(start, start + w.length));
        index = start + w.length + 1;
      }
    }
    return ranges;
  }

  int _findWordIndexForChar(int charIndex) {
    for (var i = 0; i < _wordRanges.length; i++) {
      final r = _wordRanges[i];
      if (charIndex >= r.start && charIndex < r.end) return i;
    }
    return -1;
  }

  Future<void> _markRhymeAsCompleted(RhymeItem rhyme) async {
    _completedRhymes.add(rhyme.title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_rhymes', _completedRhymes.toList());
    notifyListeners();
  }

  /// Internal helper to play chunks from [startIndex] sequentially; respects pause/stop flags.
  Future<void> _playChunksFrom(int startIndex, RhymeItem rhyme) async {
    for (var i = startIndex; i < _chunks.length; i++) {
      if (!_isPlaying || _isPaused) {
        return; // stop or pause requested
      }
      // ensure resume index points to the currently about-to-play word
      // If replayOnResume is enabled, resume should start at this same word;
      // otherwise set resume to the next word.
      _resumeIndex = _replayOnResume ? i : (i + 1);
      _currentWordIndex = i;
      notifyListeners();
      try {
        await ttsService.speak(_chunks[i]);
        // small gap to allow distinct words
        await Future.delayed(const Duration(milliseconds: 80));
      } catch (_) {
        // swallow errors and continue
      }
    }
    // finished
    _isPlaying = false;
    _currentWordIndex = -1;
    await _markRhymeAsCompleted(rhyme);
    notifyListeners();
  }

  /// Play the given rhyme's ttsText and update [currentWordIndex] as chunks
  /// are started. Uses the TextToSpeechService.speakWithProgress for smooth
  /// highlighting and falls back to inline chunk playback which supports
  /// pause/resume.
  Future<void> playRhyme(RhymeItem rhyme) async {
    if (rhyme.ttsText.trim().isEmpty) return;
    await stop(); // ensure previous playback stopped

    _chunks = _splitToWords(rhyme.ttsText);
    _wordRanges = _computeWordRanges(rhyme.ttsText, _chunks);
    _currentWordIndex = -1;
    _isPlaying = true;
    _isPaused = false;
    _resumeIndex = 0;
    notifyListeners();

    try {
      await ttsService.speakWithProgress(
        rhyme.ttsText,
        onCharIndex: (charIndex) {
          final idx = _findWordIndexForChar(charIndex);
          if (idx != -1 && idx != _currentWordIndex) {
            _currentWordIndex = idx;
            // Set the resume index according to the configured behavior.
            _resumeIndex = _replayOnResume ? idx : (idx + 1);
            notifyListeners();
          }
        },
        onComplete: () async {
          _isPlaying = false;
          _isPaused = false;
          _currentWordIndex = -1;
          _resumeIndex = 0;
          await _markRhymeAsCompleted(rhyme);
          notifyListeners();
        },
      );
    } catch (_) {
      // fallback: play chunks inline so we can pause/resume
      await _playChunksFrom(0, rhyme);
    }
  }

  /// Pause playback: stop TTS and mark paused; resume will restart from next word.
  Future<void> pause() async {
    if (!_isPlaying || _isPaused) return;
    _isPaused = true;
    await ttsService.stop();
    notifyListeners();
  }

  /// Resume playback from the last known position.
  Future<void> resume(RhymeItem rhyme) async {
    if (!_isPlaying || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
    // Continue with chunked playback starting from _resumeIndex
    await _playChunksFrom(_resumeIndex, rhyme);
  }

  Future<void> stop() async {
    _isPlaying = false;
    _isPaused = false;
    _currentWordIndex = -1;
    _resumeIndex = 0;
    notifyListeners();
    await ttsService.stop();
  }
}

class Range {
  final int start;
  final int end;
  Range(this.start, this.end);
}

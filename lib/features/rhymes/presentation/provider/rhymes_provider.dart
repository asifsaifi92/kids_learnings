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

  int _currentWordIndex = -1;
  int get currentWordIndex => _currentWordIndex;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  RhymeItem? _currentRhyme;
  RhymeItem? get currentRhyme => _currentRhyme;

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

  List<String> _splitToWords(String text) {
    if (text.trim().isEmpty) return [];
    return text.trim().split(RegExp(r"\s+"));
  }

  List<Range> _computeWordRanges(String text, List<String> words) {
    final ranges = <Range>[];
    var index = 0;
    for (var w in words) {
      final start = text.indexOf(w, index);
      if (start == -1) {
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

  /// ROBUST FALLBACK PLAYER
  Future<void> _playChunksFrom(int startIndex, RhymeItem rhyme) async {
    for (var i = startIndex; i < _chunks.length; i++) {
      // Check state BEFORE starting word
      if (!_isPlaying || _isPaused) {
        return; 
      }
      
      _resumeIndex = _replayOnResume ? i : (i + 1);
      _currentWordIndex = i;
      notifyListeners();
      
      final word = _chunks[i];
      
      try {
        // Fire TTS
        ttsService.speak(word);
        
        final int durationMs = 300 + (word.length * 60); 
        
        // Wait for the duration of the word
        await Future.delayed(Duration(milliseconds: durationMs));
        
        // CHECK AGAIN AFTER DELAY
        // This is crucial. If stop() was called during the delay, we must abort immediately.
        if (!_isPlaying || _isPaused) {
          // If we stopped, ensure TTS is actually silent
          await ttsService.stop();
          return;
        }

        // Small pause between words
        await Future.delayed(const Duration(milliseconds: 50));
        
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    
    // Finished normally
    _isPlaying = false;
    _currentWordIndex = -1;
    await _markRhymeAsCompleted(rhyme);
    notifyListeners();
  }

  Future<void> playRhyme(RhymeItem rhyme) async {
    if (rhyme.ttsText.trim().isEmpty) return;
    
    // Ensure clean state before starting
    await stop(); 

    _currentRhyme = rhyme;
    _chunks = _splitToWords(rhyme.ttsText);
    _wordRanges = _computeWordRanges(rhyme.ttsText, _chunks);
    _currentWordIndex = -1;
    _isPlaying = true;
    _isPaused = false;
    _resumeIndex = 0;
    notifyListeners();

    await _playChunksFrom(0, rhyme);
  }

  Future<void> pause() async {
    if (!_isPlaying || _isPaused) return;
    _isPaused = true;
    notifyListeners();
    // Immediately kill TTS audio
    await ttsService.stop();
  }

  Future<void> resume(RhymeItem rhyme) async {
    if (!_isPlaying || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
    await _playChunksFrom(_resumeIndex, rhyme);
  }

  Future<void> stop() async {
    _isPlaying = false;
    _isPaused = false;
    _currentWordIndex = -1;
    _resumeIndex = 0;
    notifyListeners();
    // Immediately kill TTS audio
    await ttsService.stop();
  }

  void playNext() {
    if (_currentRhyme == null || _items.isEmpty) return;
    final currentIndex = _items.indexOf(_currentRhyme!);
    if (currentIndex != -1 && currentIndex < _items.length - 1) {
      playRhyme(_items[currentIndex + 1]);
    }
  }

  void playPrevious() {
    if (_currentRhyme == null || _items.isEmpty) return;
    final currentIndex = _items.indexOf(_currentRhyme!);
    if (currentIndex > 0) {
      playRhyme(_items[currentIndex - 1]);
    }
  }
}

class Range {
  final int start;
  final int end;
  Range(this.start, this.end);
}

// lib/features/stories/presentation/provider/stories_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/story_item.dart';
import '../../domain/usecases/get_stories.dart';
import '../../../../core/services/text_to_speech_service.dart';

class StoriesProvider extends ChangeNotifier {
  final GetStories getStories;
  final TextToSpeechService ttsService;

  StoriesProvider({required this.getStories, required this.ttsService});

  Set<String> _completedStories = {};
  Set<String> get completedStories => _completedStories;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _replayOnResume = prefs.getBool('stories_replay_on_resume') ?? _replayOnResume;
    _completedStories = (prefs.getStringList('completed_stories') ?? []).toSet();
    notifyListeners();
  }

  List<StoryItem> _items = [];
  List<StoryItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getStories.call();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markStoryAsCompleted(StoryItem story) async {
    _completedStories.add(story.title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_stories', _completedStories.toList());
    notifyListeners();
  }

  void speak(String text) {
    ttsService.speak(text);
  }

  // Playback state for per-word highlighting in story pages
  int _currentWordIndex = -1;
  int get currentWordIndex => _currentWordIndex;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  // Configurable resume behavior: replay current word when true, else continue
  bool _replayOnResume = true;
  bool get replayOnResume => _replayOnResume;
  set replayOnResume(bool v) {
    _replayOnResume = v;
    SharedPreferences.getInstance().then((prefs) => prefs.setBool('stories_replay_on_resume', v));
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

  Future<void> _playChunksFrom(int startIndex) async {
    for (var i = startIndex; i < _chunks.length; i++) {
      if (!_isPlaying || _isPaused) return;
      // ensure resume index points according to replayOnResume setting
      _resumeIndex = _replayOnResume ? i : (i + 1);
      _currentWordIndex = i;
      notifyListeners();
      try {
        await ttsService.speak(_chunks[i]);
        await Future.delayed(const Duration(milliseconds: 80));
      } catch (_) {}
    }
    _isPlaying = false;
    _currentWordIndex = -1;
    notifyListeners();
  }

  Future<void> playPage(String text) async {
    if (text.trim().isEmpty) return;
    await stop();

    _chunks = _splitToWords(text);
    _wordRanges = _computeWordRanges(text, _chunks);
    _currentWordIndex = -1;
    _isPlaying = true;
    _isPaused = false;
    _resumeIndex = 0;
    notifyListeners();

    try {
      await ttsService.speakWithProgress(
        text,
        onCharIndex: (charIndex) {
          final idx = _findWordIndexForChar(charIndex);
          if (idx != -1 && idx != _currentWordIndex) {
            _currentWordIndex = idx;
            _resumeIndex = _replayOnResume ? idx : (idx + 1);
            notifyListeners();
          }
        },
        onComplete: () {
          _isPlaying = false;
          _isPaused = false;
          _currentWordIndex = -1;
          _resumeIndex = 0;
          notifyListeners();
        },
      );
    } catch (_) {
      await _playChunksFrom(0);
    }
  }

  Future<void> pause() async {
    if (!_isPlaying || _isPaused) return;
    _isPaused = true;
    await ttsService.stop();
    notifyListeners();
  }

  Future<void> resume() async {
    if (!_isPlaying || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
    await _playChunksFrom(_resumeIndex);
  }

  Future<void> stop() async {
    _isPlaying = false;
    _currentWordIndex = -1;
    _isPaused = false;
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

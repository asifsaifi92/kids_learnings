// lib/features/rhymes/presentation/provider/rhymes_provider.dart

import 'package:flutter/material.dart';
import 'package:kids/core/audio/audio_player_service.dart';
import '../../domain/entities/rhyme_item.dart';
import '../../domain/usecases/get_rhymes.dart';
import '../../../../core/services/text_to_speech_service.dart';

class RhymesProvider extends ChangeNotifier {
  final GetRhymes getRhymes;
  final TextToSpeechService ttsService;
  final AudioPlayerService audioPlayer;

  RhymesProvider({
    required this.getRhymes,
    required this.ttsService,
    required this.audioPlayer,
  });

  List<RhymeItem> _items = [];
  List<RhymeItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RhymeItem? _currentlyPlaying;
  RhymeItem? get currentlyPlaying => _currentlyPlaying;

  bool get isPlaying => audioPlayer.isPlaying;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getRhymes.call();
    _isLoading = false;
    notifyListeners();
    audioPlayer.playerStateStream.listen((_) {
      notifyListeners();
    });
  }

  void play(RhymeItem item) {
    ttsService.speak(item.ttsIntro);
    audioPlayer.playAsset(item.assetPath);
    _currentlyPlaying = item;
    notifyListeners();
  }

  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void resume() {
    audioPlayer.resume();
    notifyListeners();
  }

  void stop() {
    audioPlayer.stop();
    _currentlyPlaying = null;
    notifyListeners();
  }
}

// lib/core/audio/audio_player_service.dart

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool get isPlaying => _player.playing;

  /// Attempts to play an asset. Returns true on success, false on failure.
  Future<bool> playAsset(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      _player.play();
      return true;
    } catch (e) {
      // Log the error so the caller can decide how to handle it
      // ignore: avoid_print
      print('[AudioPlayerService] playAsset error: $e (asset: $assetPath)');
      return false;
    }
  }

  /// Play a remote URL. Returns true on success, false on failure.
  Future<bool> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('[AudioPlayerService] playUrl error: $e (url: $url)');
      return false;
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}

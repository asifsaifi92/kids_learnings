
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  // Singleton instance
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool _isSfxMuted = false;
  bool _isBgmMuted = false;

  // Initialize players
  Future<void> init() async {
    // Set BGM to loop
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // --- Sound Effects (SFX) ---

  Future<void> playClick() async {
    if (_isSfxMuted) return;
    // Stop previous SFX to allow rapid clicking
    await _sfxPlayer.stop(); 
    await _sfxPlayer.play(AssetSource('sounds/ui/click.wav'), volume: 0.5);
  }

  Future<void> playSuccess() async {
    if (_isSfxMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/ui/success.wav'));
  }

  Future<void> playPop() async {
    if (_isSfxMuted) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/ui/pop.wav'));
  }

  void toggleSfx(bool mute) {
    _isSfxMuted = mute;
  }

  // --- Background Music (BGM) ---

  Future<void> startBgm() async {
    if (_isBgmMuted) return;
    try {
      // Ensure volume is lower for BGM so it doesn't overpower TTS or SFX
      // Keeping BGM as mp3 as it's standard for long audio, but you can change to .wav if needed
      await _bgmPlayer.setVolume(0.3);
      await _bgmPlayer.play(AssetSource('sounds/ui/bgm_playful.mp3'));
    } catch (e) {
      // ignore: avoid_print
      print("Error playing BGM: $e");
    }
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  void toggleBgm(bool mute) {
    _isBgmMuted = mute;
    if (mute) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.resume();
    }
  }
}

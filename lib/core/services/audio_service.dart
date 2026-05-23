import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService(this._prefs);

  final SharedPreferences _prefs;
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgPlayer = AudioPlayer();

  static const _soundKey = 'sound_enabled';
  static const _musicKey = 'music_enabled';

  bool get soundEnabled => _prefs.getBool(_soundKey) ?? true;
  bool get musicEnabled => _prefs.getBool(_musicKey) ?? true;

  Future<void> playWordFound() => _play('audio/word_found.mp3');
  Future<void> playLevelComplete() => _play('audio/level_complete.mp3');
  Future<void> playWrong() => _play('audio/wrong.mp3');

  Future<void> startBackgroundMusic() async {
    if (!musicEnabled) return;
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(
      AssetSource('audio/bg_music.mp3'),
      volume: 0.4,
    );
  }

  Future<void> _play(String asset) async {
    if (!soundEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource(asset));
    } catch (_) {}
  }

  Future<void> toggleSound() async {
    await _prefs.setBool(_soundKey, !soundEnabled);
  }

  Future<void> toggleMusic() async {
    final next = !musicEnabled;
    await _prefs.setBool(_musicKey, next);
    if (next) {
      await startBackgroundMusic();
    } else {
      await _bgPlayer.pause();
    }
  }
}

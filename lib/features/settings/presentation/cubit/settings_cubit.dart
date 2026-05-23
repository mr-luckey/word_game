import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/services/audio_service.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.soundEnabled,
    required this.musicEnabled,
  });

  final bool soundEnabled;
  final bool musicEnabled;

  @override
  List<Object?> get props => [soundEnabled, musicEnabled];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._audio)
      : super(
          SettingsState(
            soundEnabled: _audio.soundEnabled,
            musicEnabled: _audio.musicEnabled,
          ),
        );

  final AudioService _audio;

  Future<void> toggleSound() async {
    await _audio.toggleSound();
    emit(
      SettingsState(
        soundEnabled: _audio.soundEnabled,
        musicEnabled: _audio.musicEnabled,
      ),
    );
  }

  Future<void> toggleMusic() async {
    await _audio.toggleMusic();
    emit(
      SettingsState(
        soundEnabled: _audio.soundEnabled,
        musicEnabled: _audio.musicEnabled,
      ),
    );
  }
}

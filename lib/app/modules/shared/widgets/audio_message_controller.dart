import 'dart:async';

import 'package:just_audio/just_audio.dart';

class AudioMessageController {
  final _player = AudioPlayer();

  /// id of the currently active audio message. [_updatePlayingId] should be used
  /// for switching to another audio
  String? _playingId;
  final _playingIdStreamController = StreamController<String?>.broadcast();

  AudioPlayer get player => _player;

  Stream<String?> get playingIdStream => _playingIdStreamController.stream;

  String? get playingId => _playingId;

  static final AudioMessageController _singleton = AudioMessageController._internal();

  factory AudioMessageController() {
    return _singleton;
  }

  Future<Duration?> startNewAudio(String url, String id) async {
    await _player.stop();
    await _player.seek(Duration.zero);

    _updatePlayingId(id);

    final duration = _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
      ),
    );

    _player.play();

    return duration;
  }

  void _updatePlayingId(String? id) {
    _playingId = id;
    _playingIdStreamController.add(id);
  }

  AudioMessageController._internal();
}

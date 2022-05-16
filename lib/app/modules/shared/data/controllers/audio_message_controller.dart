import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:just_audio/just_audio.dart';

class AudioMessageController extends GetxController {
  final _player = AudioPlayer();
  final playingId = "".obs;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;

  late StreamSubscription durationListener;
  late StreamSubscription positionListener;
  late StreamSubscription playerStateListener;

  AudioPlayer get player => _player;

  @override
  void onInit() {
    super.onInit();
    durationListener = _player.durationStream.listen((event) {
      // Todo: correct message metadata if necessary
      duration.value = event ?? duration.value;
    });
    positionListener = _player.positionStream.listen((event) {
      position.value = event;
    });

    playerStateListener = _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    durationListener.cancel();
    positionListener.cancel();
    playerStateListener.cancel();
  }

  void seek(String id, double value) {
    if (playingId.value != id) {
      return;
    }

    final dSeconds = duration.value.inSeconds;
    if (dSeconds <= 0) {
      return;
    }

    _player.seek(Duration(seconds: (dSeconds * value).toInt()));
  }

  void playOrPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void startNewAudio(AudioMessageModel message) async {
    await _player.stop();
    await _player.seek(Duration.zero);

    playingId.value = message.messageId;
    final metadata = message.metadata;
    duration.value = Duration(seconds: metadata.durationInSeconds);

    // Todo: check whether local url exists or not
    _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(message.localUrl ?? message.url),
      ),
    );

    _player.play();
  }
}

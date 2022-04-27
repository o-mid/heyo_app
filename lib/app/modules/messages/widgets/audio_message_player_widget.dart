import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/message_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:just_audio/just_audio.dart';

class AudioMessagePlayer extends StatefulWidget {
  final MessageModel message;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color activeSliderColor;
  final Color inactiveSliderColor;
  const AudioMessagePlayer({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.activeSliderColor,
    required this.inactiveSliderColor,
  }) : super(key: key);

  @override
  State<AudioMessagePlayer> createState() => _AudioMessagePlayerState();
}

class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
  double _sliderValue = 0;
  int _durationInSeconds = 0;
  String? _playingId = AudioMessageController().playingId;

  StreamSubscription? _durationListener;
  StreamSubscription? _positionListener;
  StreamSubscription? _playerStateListener;
  StreamSubscription? _playingIdListener;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _cancelPlayerListeners();
    _playingIdListener?.cancel();

    // Todo: should be removed if a global player is implemented
    AudioMessageController().player.pause();
    super.dispose();
  }

  Future<void> _init() async {
    final metadata = widget.message.metadata;

    final controller = AudioMessageController();

    if (metadata != null && metadata is AudioMetadata) {
      _durationInSeconds = metadata.durationInSeconds;
    }

    _playingIdListener = controller.playingIdStream.listen((event) {
      setState(() {
        _playingId = event;
      });

      if (event == widget.message.messageId) {
        _startPlayerListeners();
      } else {
        _cancelPlayerListeners();
      }
    });

    if (_isActive()) {
      _startPlayerListeners();
      _durationInSeconds =
          controller.playingId == widget.message.messageId && controller.player.duration != null
              ? controller.player.duration!.inSeconds
              : _durationInSeconds;
    }
  }

  void _startPlayerListeners() {
    _cancelPlayerListeners();

    final player = AudioMessageController().player;

    _positionListener = player.positionStream.listen((event) {
      if (_durationInSeconds == 0) {
        _sliderValue = 0;
      } else {
        _sliderValue = event.inSeconds / _durationInSeconds;
        _sliderValue = min(1, _sliderValue);
      }
      setState(() {});
    });

    _playerStateListener = player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        player.pause();
        player.seek(Duration.zero);
      }
    });
  }

  void _cancelPlayerListeners() {
    _durationListener?.cancel();
    _positionListener?.cancel();
    _playerStateListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: widget.backgroundColor,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _playOrPause,
              child: SizedBox(
                width: 20.w,
                child: ScaleAnimatedSwitcher(
                  child: _isPlaying()
                      ? Icon(
                          Icons.pause,
                          color: widget.iconColor,
                          size: 28.r,
                        )
                      : Assets.svg.playIcon.svg(
                          color: widget.iconColor,
                        ),
                ),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
                  trackHeight: 2.h,
                ),
                child: Slider(
                  inactiveColor: widget.inactiveSliderColor,
                  activeColor: widget.activeSliderColor,
                  value: _sliderValue,
                  onChanged: _seek,
                ),
              ),
            ),
            Text(
              _getAudioDuration(),
              style: TEXTSTYLES.kChatLink.copyWith(color: widget.textColor),
            ),
          ],
        ),
      ),
    );
  }

  String _getAudioDuration() {
    if (_durationInSeconds == 0) {
      return "0:00";
    }

    return "${_durationInSeconds ~/ 60}:${(_durationInSeconds % 60).toString().padLeft(2, '0')}";
  }

  void _seek(double value) {
    if (_playingId != widget.message.messageId) {
      return;
    }

    final player = AudioMessageController().player;
    final duration = player.duration;
    if (duration == null) {
      return;
    }
    final newPosition = duration.inSeconds * value;

    player.seek(Duration(seconds: newPosition.toInt()));
  }

  bool _isActive() => _playingId == widget.message.messageId;

  bool _isPlaying() {
    return _isActive() && AudioMessageController().player.playing;
  }

  void _playOrPause() async {
    final controller = AudioMessageController();
    if (_playingId != widget.message.messageId) {
      final duration =
          await controller.startNewAudio(widget.message.payload, widget.message.messageId);

      if (duration != null) {
        setState(() {
          _durationInSeconds = duration.inSeconds;
        });
      }
      return;
    }

    if (controller.player.playing) {
      controller.player.pause();
    } else {
      controller.player.play();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color activeSliderColor;
  final Color inactiveSliderColor;
  const AudioPlayerWidget({
    Key? key,
    required this.url,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.activeSliderColor,
    required this.inactiveSliderColor,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();

  double _sliderValue = 0;
  int _durationInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _player.durationStream.listen((event) {
      if (event == null) {
        return;
      }

      setState(() {
        _durationInSeconds = event.inSeconds;
      });
    });

    _player.positionStream.listen((event) {
      if (_durationInSeconds == 0) {
        _sliderValue = 0;
      } else {
        _sliderValue = event.inSeconds / _durationInSeconds;
      }
      setState(() {});
    });

    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });

    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.url),
        ),
      );
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
                  child: _player.playing
                      ? Icon(
                          Icons.pause,
                          color: widget.iconColor,
                          size: 28,
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
    final duration = _player.duration;
    if (duration == null) {
      return;
    }
    final newPosition = duration.inSeconds * value;

    _player.seek(Duration(seconds: newPosition.toInt()));
  }

  void _playOrPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }
}

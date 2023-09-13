import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';
import 'package:heyo/generated/assets.gen.dart';

class AudioMessagePlayer extends GetView<AudioMessageController> {
  final AudioMessageModel message;
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: _containerPadding(),
        decoration: _containerDecoration(),
        child: Obx(() => _buildAudioControls()),
      ),
    );
  }

  EdgeInsets _containerPadding() => EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w);

  BoxDecoration _containerDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: backgroundColor,
      );

  Widget _buildAudioControls() {
    final isActive = controller.playingId.value == message.messageId;

    return Row(
      children: [
        _buildPlayPauseButton(isActive),
        _buildSlider(isActive),
        _buildDurationText(isActive),
      ],
    );
  }

  Widget _buildPlayPauseButton(bool isActive) {
    return GestureDetector(
      onTap: isActive ? controller.playOrPause : () => controller.startNewAudio(message),
      child: SizedBox(
        width: 20.w,
        child: ScaleAnimatedSwitcher(
          child: _playPauseIcon(isActive),
        ),
      ),
    );
  }

  Widget _playPauseIcon(bool isActive) {
    if (isActive && controller.player.playing) {
      return Icon(
        Icons.pause,
        color: iconColor,
        size: 28.r,
      );
    } else {
      return Assets.svg.playIcon.svg(color: iconColor);
    }
  }

  Widget _buildSlider(bool isActive) {
    return Expanded(
      child: SliderTheme(
        data: _sliderThemeData(),
        child: Slider(
          inactiveColor: inactiveSliderColor,
          activeColor: activeSliderColor,
          value:
              isActive ? _getSliderValue(controller.position.value, controller.duration.value) : 0,
          onChanged: (value) => controller.seek(message.messageId, value),
        ),
      ),
    );
  }

  SliderThemeData _sliderThemeData() => SliderThemeData(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
        trackHeight: 2.h,
      );

  Widget _buildDurationText(bool isActive) {
    return Text(
      _durationToString(isActive ? controller.duration.value : null),
      style: TEXTSTYLES.kChatLink.copyWith(color: textColor),
    );
  }

  String _durationToString(Duration? duration) {
    duration ??= Duration(seconds: message.metadata.durationInSeconds);
    return "${duration.inSeconds ~/ 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  double _getSliderValue(Duration position, Duration total) {
    if (total.inSeconds == 0) {
      return 0;
    }
    return min(1, position.inSeconds / total.inSeconds);
  }
}

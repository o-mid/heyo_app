import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:record/record.dart';

class ActiveRecorderWidget extends StatefulWidget {
  final Function onSend;
  final VoidCallback onCancel;
  const ActiveRecorderWidget({
    Key? key,
    required this.onSend,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ActiveRecorderWidget> createState() => _ActiveRecorderWidgetState();
}

class _ActiveRecorderWidgetState extends State<ActiveRecorderWidget> {
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${(_recordDuration ~/ 60).toString().padLeft(2, '0')}:${(_recordDuration % 60).toString().padLeft(2, '0')}",
            style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kDarkBlueColor),
          ),
        ),
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _cancel,
                child: Assets.svg.closeSignOutline.svg(
                  width: 20.h,
                  height: 20.h,
                ),
              ),
              if (_isPaused)
                GestureDetector(
                  onTap: _resume,
                  child: Assets.svg.pauseRecordOutlinedIcon.svg(
                    width: 32.h,
                    height: 32.h,
                  ),
                ),
              if (!_isPaused)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffFFE5E5),

                        /// Linear interpolation of x1 = -40, y1 = 0 and x2 = 0, y2 = 16
                        /// y1 is the min and y2 the max spread radius
                        spreadRadius:
                            max(0, 0.4 * (_amplitude?.current ?? -40) + 16).h,
                        blurStyle: BlurStyle.solid,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: _pause,
                    child: Assets.svg.pauseRecordIcon.svg(
                      width: 32.h,
                      height: 32.h,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: _send,
                child: Assets.svg.sendIcon.svg(
                  width: 17.h,
                  height: 17.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _recordDuration = 0;
        });

        if (isRecording) {
          _startTimers();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _send() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onSend(path!, _recordDuration);

    setState(() => _isPaused = true);
  }

  Future<void> _cancel() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.stop();

    widget.onCancel();
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimers();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimers() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}

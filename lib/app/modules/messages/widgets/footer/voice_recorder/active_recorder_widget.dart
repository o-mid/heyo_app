import 'dart:async';

import 'package:flutter/material.dart';
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
  // Todo: use amplitude for pulsing
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
                child: Assets.svg.closeSignOutline.svg(),
              ),
              if (_isPaused)
                GestureDetector(
                  onTap: _resume,
                  child: Assets.svg.pauseRecordOutlinedIcon.svg(),
                ),
              if (!_isPaused)
                GestureDetector(
                  onTap: _pause,
                  child: Assets.svg.pauseRecordIcon.svg(),
                ),
              GestureDetector(
                onTap: _send,
                child: Assets.svg.sendIcon.svg(),
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

    _ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}

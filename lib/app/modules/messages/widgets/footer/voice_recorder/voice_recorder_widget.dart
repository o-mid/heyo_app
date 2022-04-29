import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import 'active_recorder_widget.dart';
import 'initial_recorder_widget.dart';

class VoiceRecorderWidget extends StatefulWidget {
  const VoiceRecorderWidget({Key? key}) : super(key: key);

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  var isRecording = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Ink(
      decoration: const BoxDecoration(
        color: COLORS.kComposeMessageBackgroundColor,
        border: Border(
          top: BorderSide(
            width: 1,
            color: COLORS.kComposeMessageBorderColor,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(18.h),
        height: 200.h,
        width: double.infinity,
        child: isRecording
            ? ActiveRecorderWidget(
                onSend: (String path, int durationSeconds) {
                  controller.isInRecordMode.value = false;
                  controller.sendAudioMessage(path, durationSeconds);
                },
                onCancel: () => controller.isInRecordMode.value = false,
              )
            : InitialRecorderWidget(
                onCancel: () => controller.isInRecordMode.value = false,
                onRecord: () {
                  setState(() {
                    isRecording = true;
                  });
                },
              ),
      ),
    );
  }
}

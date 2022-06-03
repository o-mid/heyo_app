import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';

class RecordCallButton extends StatelessWidget {
  const RecordCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();

    return Obx(() {
      switch (controller.recordState.value) {
        case RecordState.notRecording:
          return CircleIconButton.p16(
            onPressed: controller.recordCall,
            backgroundColor: COLORS.kCallPageDarkGrey,
            icon: Assets.svg.recordWordIcon.svg(
              width: 48.w,
              height: 48.w,
              color: COLORS.kWhiteColor,
            ),
          );
        case RecordState.loading:
          return Stack(
            children: [
              const Positioned.fill(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: COLORS.kCallPageDarkGrey,
                ),
              ),
              CircleIconButton.p16(
                backgroundColor: Colors.transparent,
                icon: Assets.svg.recordWordIcon.svg(
                  width: 48.w,
                  height: 48.w,
                  color: COLORS.kWhiteColor,
                ),
              ),
            ],
          );
        case RecordState.recording:
          return CircleIconButton.p16(
            onPressed: controller.stopRecording,
            backgroundColor: COLORS.kWhiteColor,
            icon: Assets.svg.recordWordIcon.svg(
              width: 48.w,
              height: 48.w,
              color: COLORS.kStatesErrorColor,
            ),
          );
      }
    });
  }
}

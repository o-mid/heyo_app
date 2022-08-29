import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_no_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/caller_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/draggable_video.dart';
import 'package:heyo/app/modules/calls/main/widgets/group_call_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class CallInProgressWidget extends StatelessWidget {
  const CallInProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Obx(() {
      if (controller.isGroupCall) {
        return const GroupCallWidget();
      }

      final calleeWidget = controller.calleeVideoEnabled.value
          ? const CalleeVideoWidget()
          : const CalleeNoVideoWidget();

      final callerWidget = controller.callerVideoEnabled.value
          ? const CallerVideoWidget()
          : controller.isVideoPositionsFlipped.isTrue
              ? const CalleeNoVideoWidget()
              : const SizedBox.shrink();

      final firstWidget = controller.isVideoPositionsFlipped.isFalse ? calleeWidget : callerWidget;

      final secondWidget = controller.isVideoPositionsFlipped.isFalse
          ? callerWidget
          : controller.calleeVideoEnabled.value
              ? calleeWidget
              : const SizedBox.shrink();

      switch (controller.callViewType.value) {
        case CallViewType.column:
          return Center(
            child: Column(
              children: [
                Expanded(child: firstWidget),
                Expanded(child: secondWidget),
                const Spacer(),
              ],
            ),
          );
        case CallViewType.row:
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(
                flex: 1,
              ),
              Obx(() {
                return Text(
                  "${controller.callDurationSeconds.value ~/ 60}:${(controller.callDurationSeconds.value % 60).toString().padLeft(2, "0")}",
                  style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kWhiteColor),
                );
              }),
              CustomSizes.largeSizedBoxHeight,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: AspectRatio(
                          aspectRatio: 175 / 318,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              child: firstWidget))),
                  Expanded(
                      child: AspectRatio(
                          aspectRatio: 175 / 318,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              child: secondWidget))),
                ],
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          );
        case CallViewType.stack:
          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: firstWidget,
                ),
                DraggableVideo(
                  child: SizedBox(
                    width: 96.w,
                    height: 144.h,
                    child: secondWidget,
                  ),
                ),
              ],
            ),
          );
      }
    });
  }
}

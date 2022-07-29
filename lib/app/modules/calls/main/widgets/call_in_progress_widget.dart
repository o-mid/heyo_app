import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_no_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/caller_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/draggable_video.dart';
import 'package:heyo/app/modules/calls/main/widgets/group_call_widget.dart';

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
                const Spacer(),
                Expanded(child: firstWidget),
                Expanded(child: secondWidget),
                const Spacer(),
              ],
            ),
          );
        case CallViewType.row:
          return Row(
            children: [
              Expanded(child: firstWidget),
              Expanded(child: secondWidget),
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

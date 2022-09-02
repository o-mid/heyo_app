import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_view_type_column_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_view_type_row_widget.dart';
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
      final bool changeCallerWidgetSize = controller.showCallerOptions.value &&
          controller.callViewType.value == CallViewType.stack &&
          controller.isVideoPositionsFlipped.isFalse;

      final firstWidget = controller.isVideoPositionsFlipped.isFalse ? calleeWidget : callerWidget;

      final secondWidget = controller.isVideoPositionsFlipped.isFalse
          ? callerWidget
          : controller.calleeVideoEnabled.value
              ? calleeWidget
              : const SizedBox.shrink();

      switch (controller.callViewType.value) {
        case CallViewType.column:
          return CallViewTypeColumnWidget(firstWidget: firstWidget, secondWidget: secondWidget);
        case CallViewType.row:
          return CallViewTypeRowWidget(firstWidget: firstWidget, secondWidget: secondWidget);
        case CallViewType.stack:
          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: firstWidget,
                ),
                DraggableVideo(
                  child: AnimatedSize(
                    clipBehavior: Clip.hardEdge,
                    curve: Curves.easeInOut,
                    alignment: Alignment.bottomLeft,
                    duration: controller.callerScaleDuration,
                    reverseDuration: controller.callerScaleReverseDuration,
                    child: SizedBox(
                      width: changeCallerWidgetSize ? 184.w : 96.w,
                      height: changeCallerWidgetSize ? 257.h : 144.h,
                      child: secondWidget,
                    ),
                  ),
                ),
              ],
            ),
          );
      }
    });
  }
}

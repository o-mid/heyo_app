import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_view_type_column_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_view_type_row_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_view_type_stack_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_no_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/caller_video_widget.dart';

class CallInProgressWidget extends StatelessWidget {
  const CallInProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Obx(() {
      //if (controller.isGroupCall) {
      //  return const GroupCallWidget();
      //}

      final calleeWidget = controller.calleeVideoEnabled.value
          ? const CalleeVideoWidget()
          : const CalleeNoVideoWidget();

      final callerWidget = controller.callerVideoEnabled.value
          ? const CallerVideoWidget()
          : controller.isVideoPositionsFlipped.isTrue
              ? const CalleeNoVideoWidget()
              : const SizedBox.shrink();

      final firstWidget = controller.isVideoPositionsFlipped.isFalse
          ? calleeWidget
          : callerWidget;

      final secondWidget = controller.isVideoPositionsFlipped.isFalse
          ? callerWidget
          : controller.calleeVideoEnabled.value
              ? calleeWidget
              : const SizedBox.shrink();

      return CallViewTypeStackWidget(
        firstWidget: firstWidget,
        secondWidget: secondWidget,
      );

      //switch (controller.callViewType.value) {
      //  case CallViewType.column:
      //    return CallViewTypeColumnWidget(
      //      firstWidget: firstWidget,
      //      secondWidget: secondWidget,
      //    );
      //  case CallViewType.row:
      //    return CallViewTypeRowWidget(
      //      firstWidget: firstWidget,
      //      secondWidget: secondWidget,
      //    );
      //  case CallViewType.stack:
      //    return CallViewTypeStackWidget(
      //      firstWidget: firstWidget,
      //      secondWidget: secondWidget,
      //    );
      //}
    });
  }
}

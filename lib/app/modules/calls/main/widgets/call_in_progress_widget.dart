import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_no_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/callee_video_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/caller_video_widget.dart';

class CallInProgressWidget extends StatelessWidget {
  const CallInProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Obx(() {
      final calleeWidget = controller.calleeVideoEnabled.value
          ? const CalleeVideoWidget()
          : const CalleeNoVideoWidget();

      final callerWidget = controller.callerVideoEnabled.value
          ? Positioned(
              top: 16.h,
              right: 16.h,
              child: SizedBox(
                width: 96.w,
                height: 144.h,
                child: const CallerVideoWidget(),
              ),
            )
          : const SizedBox.shrink();
      switch (controller.callViewType.value) {
        case CallViewType.column:
          return Center(
            child: Column(
              children: [
                const Spacer(),
                Expanded(child: calleeWidget),
                Expanded(child: callerWidget),
                const Spacer(),
              ],
            ),
          );
        case CallViewType.row:
          return Row(
            children: [
              Expanded(child: calleeWidget),
              Expanded(child: callerWidget),
            ],
          );
        case CallViewType.stack:
          return Stack(
            children: [
              Positioned.fill(
                child: controller.calleeVideoEnabled.value
                    ? const CalleeVideoWidget()
                    : const CalleeNoVideoWidget(),
              ),
              if (controller.callerVideoEnabled.value)
                Positioned(
                  top: 16.h,
                  right: 16.h,
                  child: SizedBox(
                    width: 96.w,
                    height: 144.h,
                    child: const CallerVideoWidget(),
                  ),
                ),
            ],
          );
      }
    });
  }
}

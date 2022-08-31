import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
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
      final bool changeCallerWidgetSize = controller.showCallerOptions.value &&
          controller.callViewType.value == CallViewType.stack &&
          controller.isVideoPositionsFlipped.isFalse;

      final firstWidget = controller.isVideoPositionsFlipped.isFalse ? calleeWidget : callerWidget;

      final secondWidget = controller.isVideoPositionsFlipped.isFalse
          ? callerWidget
          : controller.calleeVideoEnabled.value
              ? calleeWidget
              : const SizedBox.shrink();

      List<DraggableGridItem> draggableRowChidren = [
        DraggableGridItem(
          isDraggable: true,
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AspectRatio(
                aspectRatio: controller.callRowViewAspectRatio,
                child: firstWidget,
              )),
        ),
        DraggableGridItem(
          isDraggable: true,
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AspectRatio(
                aspectRatio: controller.callRowViewAspectRatio,
                child: secondWidget,
              )),
        ),
      ];
      switch (controller.callViewType.value) {
        case CallViewType.column:
          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: controller.callColumnViewAspectRatio,
                      child: firstWidget,
                    ),
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: controller.callColumnViewAspectRatio,
                      child: secondWidget,
                    ),
                  ),
                  SizedBox(
                    height: controller.isImmersiveMode.value ? 8.h : 100.h,
                  )
                ],
              ),
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
              Expanded(
                flex: 5,
                child: DraggableGridViewBuilder(
                  dragPlaceHolder: (List<DraggableGridItem> list, int index) {
                    return PlaceHolderWidget(
                      child: Container(
                        color: Colors.transparent,
                      ),
                    );
                  },
                  dragFeedback: (List<DraggableGridItem> list, int index) {
                    return list[index].child;
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: controller.callRowViewAspectRatio,
                  ),
                  dragCompletion: (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
                    print('onDragAccept: $beforeIndex -> $afterIndex');
                  },
                  children: draggableRowChidren,
                ),
              ),
              // const Spacer(
              //   flex: 1,
              // ),
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

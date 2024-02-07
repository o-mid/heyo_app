import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_renderer_local_stack_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/draggable_video.dart';
import 'package:heyo/app/modules/calls/main/widgets/group_call_renderer_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';

class GroupCallWidget extends GetView<CallController> {
  const GroupCallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //final allVideoRenderers = controller.getAllConnectedParticipate();
    final localParticipate = controller.localParticipate;
    final remoteParticipate = controller.connectedRemoteParticipates;
    return Obx(() {
      final changeCallerWidgetSize = controller.showCallerOptions.value &
          controller.isVideoPositionsFlipped.isFalse;

      if (remoteParticipate.isEmpty || localParticipate.value == null) {
        return const Center(child: Text('No remote videos available.'));
      }

      final size = MediaQuery.of(context).size;

      final toolBarHeight =
          controller.fullScreenMode.isFalse ? kToolbarHeight : 0;

      //* The height og expanded bottom sheet is ~100
      final expandedHeaderHeight = controller.fullScreenMode.isFalse ? 100 : 0;

      //* 24 is for notification bar on Android
      final itemHeight =
          (size.height - toolBarHeight - expandedHeaderHeight - 24) /
              (remoteParticipate.length / 2).ceil();
      final itemWidth = size.width / 2;

      return Stack(
        children: [
          GridView.builder(
            //physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //* The only exception that we have is in 2 remotes
              //* we have to show them like Column(every axis one renderer)
              crossAxisCount: remoteParticipate.length == 2 ? 1 : 2,
              childAspectRatio: remoteParticipate.length == 2
                  ? size.width / itemHeight * 2
                  : itemWidth / itemHeight,
              //childAspectRatio: ScreenUtil.defaultSize.aspectRatio *
              //    (remoteParticipate.length == 2 ? 2 : 1),
            ),
            itemCount: remoteParticipate.length,
            itemBuilder: (context, index) {
              return GroupCallRendererWidget(
                participantModel: remoteParticipate[index],
                participantCount: remoteParticipate.length,
              );
            },
          ),
          if (localParticipate.value!.videoMode.isTrue)
            DraggableVideo(
              child: AnimatedSize(
                clipBehavior: Clip.hardEdge,
                curve: TRANSITIONS.callPage_DraggableVideoAnimatedSizeCurve,
                alignment: Alignment.bottomLeft,
                duration: controller.callerScaleDuration,
                reverseDuration: controller.callerScaleReverseDuration,
                child: SizedBox(
                  width: changeCallerWidgetSize ? 200.w : 120.w,
                  height: changeCallerWidgetSize ? 250.h : 170.h,
                  child: GestureDetector(
                    //TODO: AliAzim => check if we need this onTap & onDoubleTap or not
                    onTap: controller.changeCallerOptions,
                    onDoubleTap: controller.flipVideoPositions,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: CallRendererLocalStackWidget(
                        participantModel: localParticipate.value!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

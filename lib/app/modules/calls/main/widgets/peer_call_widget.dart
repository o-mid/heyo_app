import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_renderer_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/draggable_video.dart';
import 'package:heyo/app/modules/calls/shared/data/models/local_participant_model/local_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';

class PeerCallWidget extends GetView<CallController> {
  const PeerCallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localParticipate = controller.localParticipate;
    final remoteParticipate = controller.connectedRemoteParticipates;
    return Obx(() {
      final changeCallerWidgetSize = controller.showCallerOptions.value &
          controller.isVideoPositionsFlipped.isFalse;

      if (remoteParticipate.isEmpty || localParticipate.value == null) {
        return const Center(child: Text('No remote videos available.'));
      }

      return SafeArea(
        child: Stack(
          children: [
            //* The remote video that will get whole screen
            CallRendererWidget(
              participantModel: remoteParticipate.first,
            ),
            //* The local drapable video
            DraggableVideo(
              child: AnimatedSize(
                clipBehavior: Clip.hardEdge,
                curve: TRANSITIONS.callPage_DraggableVideoAnimatedSizeCurve,
                alignment: Alignment.bottomLeft,
                duration: controller.callerScaleDuration,
                reverseDuration: controller.callerScaleReverseDuration,
                child: SizedBox(
                  width: changeCallerWidgetSize ? 184.w : 96.w,
                  height: changeCallerWidgetSize ? 257.h : 144.h,
                  child: GestureDetector(
                    //TODO: AliAzim => check if we need this onTap & onDoubleTap or not
                    onTap: controller.changeCallerOptions,
                    onDoubleTap: controller.flipVideoPositions,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: CallRendererWidget(
                        participantModel: localParticipate.value!
                            .mapToConnectedParticipantModel(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

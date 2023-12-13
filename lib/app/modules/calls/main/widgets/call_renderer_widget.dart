import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CallRendererWidget extends StatelessWidget {
  const CallRendererWidget({
    required this.participantModel,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    super.key,
  });

  final ConnectedParticipantModel participantModel;
  final RTCVideoViewObjectFit objectFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: COLORS.kCallPageDarkGrey),
      child: participantModel.videoMode.value
          ? RTCVideoView(
              participantModel.rtcVideoRenderer!,
              objectFit: objectFit,
              mirror: true,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CalleeOrCallerInfoWidget(
                      name: participantModel.name,
                      coreId: participantModel.coreId,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

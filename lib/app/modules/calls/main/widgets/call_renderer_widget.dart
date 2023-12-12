import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CallRendererWidget extends StatelessWidget {
  const CallRendererWidget({required this.participantModel, super.key});

  final ConnectedParticipantModel participantModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLORS.kCallPageDarkGrey,
        border: Border.all(
          color: Colors.black54,
          width: 0.5,
        ),
      ),
      // TODO(AliAzim): the condition for voice and video call should add in here.
      child: participantModel.videoMode.value
          ? RTCVideoView(
              participantModel.rtcVideoRenderer!,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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

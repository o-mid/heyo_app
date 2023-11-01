import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CallRendererWidget extends StatelessWidget {
  const CallRendererWidget({required this.participantModel, super.key});

  final ConnectedParticipantModel participantModel;

  @override
  Widget build(BuildContext context) {
    //TODO: AliAzim => the condition for voice and video call should add in here
    return participantModel.videoMode.value
        ? RTCVideoView(
            participantModel.rtcVideoRenderer!,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
        : Container(
            color: COLORS.kBlueColor,
          );
  }
}

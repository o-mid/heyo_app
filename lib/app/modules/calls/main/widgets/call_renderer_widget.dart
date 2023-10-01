import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participate_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CallRendererWidget extends StatelessWidget {
  const CallRendererWidget({super.key, required this.participateModel});

  final ConnectedParticipateModel participateModel;

  @override
  Widget build(BuildContext context) {
    //TODO: AliAzim => the condition for voice and video call should add in here
    return participateModel.videoMode
        ? RTCVideoView(
            participateModel.rtcVideoRenderer!,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
        : Container(
            color: COLORS.kBlueColor,
          );
  }
}

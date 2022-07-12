import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';

// Todo: replace this with remote video webrtc
class CalleeVideoWidget extends StatelessWidget {
  const CalleeVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      id: "callee",
      builder: (controller) {
        RTCVideoRenderer remoteVideRenderer =
            controller.getRemoteVideRenderer();

        return GestureDetector(
          onTap: controller.toggleImmersiveMode,
          onDoubleTap: controller.flipVideoPositions,
          child: Flexible(
              child: Container(
            key: const Key('remote'),
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: RTCVideoView(remoteVideRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
          )),
        );
      },
    );
  } //
}

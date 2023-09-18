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
      id: Get.find<CallController>().calleeVideoWidgetId,
      builder: (controller) {
        List<RTCVideoRenderer> remoteVideoRenderers =
            controller.getRemoteVideRenderer();

        return ListView.builder(
          itemCount: remoteVideoRenderers.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            RTCVideoRenderer remoteVideoRenderer = remoteVideoRenderers[index];

            return Container(
              key: Key('remote_$index'), // Unique key for each video renderer
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: GestureDetector(
                onTap: controller.toggleImmersiveMode,
                onDoubleTap: controller.flipVideoPositions,
                child: RTCVideoView(
                  remoteVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

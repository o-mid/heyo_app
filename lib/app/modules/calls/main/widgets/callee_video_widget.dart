import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';

class CalleeVideoWidget extends GetView<CallController> {
  const CalleeVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteVideoRenderers = controller.getRemoteVideoRenderers();

    //* Calculate the number of rows needed based on the number of items.
    int rowCount = (remoteVideoRenderers.length / 2).ceil();

    return Obx(() {
      return Wrap(
        runSpacing: 5,
        children: List.generate(
          rowCount,
          (rowIndex) {
            if (rowIndex == 0 && remoteVideoRenderers.length % 2 != 0) {
              //TODO: below step will be removed beacuse we show the local video
              //* First row with an odd number of items, use one full width.
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RTCVideoView(
                  remoteVideoRenderers[rowIndex * 2],
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              );
            } else {
              //* Rows with two items each.
              return Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 -
                        5, // Half width with spacing
                    child: RTCVideoView(
                      remoteVideoRenderers[rowIndex * 2],
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 5,
                    child: RTCVideoView(
                      remoteVideoRenderers[rowIndex * 2 + 1],
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    });
  }
}

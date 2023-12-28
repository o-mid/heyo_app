//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'package:get/get.dart';

//import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';

//class CalleeVideoWidget extends GetView<CallController> {
//  const CalleeVideoWidget({Key? key}) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//    final remoteVideoRenderers = controller.getRemoteVideoRenderers();
//    return Obx(() {
//      if (remoteVideoRenderers.isEmpty) {
//        return const Center(child: Text('No remote videos available.'));
//      }

//      if (remoteVideoRenderers.length <= 1) {
//        // If there are 2 or fewer remote videos, display them in a simple column.
//        return Column(
//          children: remoteVideoRenderers.map((renderer) {
//            return SizedBox(
//              height:
//                  ScreenUtil.defaultSize.height / remoteVideoRenderers.length,
//              child: RTCVideoView(
//                renderer,
//                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//              ),
//            );
//          }).toList(),
//        );
//      } else {
//        // If there are more than 2 remote videos, display them in a grid.
//        return Column(
//          children: [
//            Expanded(
//              child: GridView.builder(
//                shrinkWrap: true,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: remoteVideoRenderers.length == 2 ? 1 : 2,
//                  childAspectRatio: ScreenUtil.defaultSize.aspectRatio *
//                      (remoteVideoRenderers.length == 2 ? 2 : 1),
//                ),
//                itemCount: remoteVideoRenderers.length,
//                itemBuilder: (context, index) {
//                  return RTCVideoView(
//                    remoteVideoRenderers[index],
//                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                  );
//                },
//              ),
//            ),
//            //* This sizeBox is because of call bottom sheet header
//            SizedBox(height: 70.h)
//          ],
//        );
//      }
//    });
//  }
//}

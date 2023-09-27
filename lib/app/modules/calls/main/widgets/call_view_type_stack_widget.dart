//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
//import 'package:heyo/app/modules/calls/main/widgets/draggable_video.dart';

//import '../../../shared/utils/constants/transitions_constant.dart';

//class CallViewTypeStackWidget extends StatelessWidget {
//  CallViewTypeStackWidget({
//    Key? key,
//    required this.firstWidget,
//    required this.secondWidget,
//  }) : super(key: key);

//  final Widget firstWidget;
//  final controller = Get.find<CallController>();

//  final Widget secondWidget;

//  @override
//  Widget build(BuildContext context) {
//    return Obx(() {
//      final bool changeCallerWidgetSize = controller.showCallerOptions.value &&
//          controller.callViewType.value == CallViewType.stack &&
//          controller.isVideoPositionsFlipped.isFalse;
//      return SafeArea(
//        child: Stack(
//          children: [
//            Align(
//              alignment: Alignment.center,
//              child: firstWidget,
//            ),
//            DraggableVideo(
//              child: AnimatedSize(
//                clipBehavior: Clip.hardEdge,
//                curve: TRANSITIONS.callPage_DraggableVideoAnimatedSizeCurve,
//                alignment: Alignment.bottomLeft,
//                duration: controller.callerScaleDuration,
//                reverseDuration: controller.callerScaleReverseDuration,
//                child: SizedBox(
//                  width: changeCallerWidgetSize ? 184.w : 96.w,
//                  height: changeCallerWidgetSize ? 257.h : 144.h,
//                  child: secondWidget,
//                ),
//              ),
//            ),
//          ],
//        ),
//      );
//    });
//  }
//}

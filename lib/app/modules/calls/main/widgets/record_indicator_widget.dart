//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
//import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
//import 'package:heyo/generated/assets.gen.dart';

//class RecordIndicatorWidget extends StatelessWidget
//    implements PreferredSizeWidget {
//  const RecordIndicatorWidget({Key? key}) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//    final controller = Get.find<CallController>();
//    return Obx(() {
//      final recordState = controller.recordState.value;
//      if (recordState == RecordState.notRecording) {
//        return const SizedBox.shrink();
//      }

//      return Container(
//        alignment: Alignment.centerLeft,
//        width: double.infinity,
//        height: 34.h,
//        color: recordState == RecordState.recording
//            ? COLORS.kStatesErrorColor
//            : COLORS.kCallPageDarkBlue,
//        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//        child: Row(
//          children: [
//            if (recordState == RecordState.recording)
//              Container(
//                width: 10.w,
//                height: 10.w,
//                decoration: const BoxDecoration(
//                  color: COLORS.kWhiteColor,
//                  shape: BoxShape.circle,
//                ),
//              ),
//            if (recordState == RecordState.loading)
//              SizedBox(
//                width: 10.w,
//                height: 10.w,
//                child: const CircularProgressIndicator(
//                  strokeWidth: 1,
//                  color: COLORS.kWhiteColor,
//                ),
//              ),
//            SizedBox(width: 2.w),
//            Assets.svg.recordWordIcon.svg(color: COLORS.kWhiteColor),
//          ],
//        ),
//      );
//    });
//  }

//  @override
//  Size get preferredSize => Size(
//        double.infinity,
//        Get.find<CallController>().recordState.value == RecordState.notRecording
//            ? 0
//            : 34,
//      );
//}

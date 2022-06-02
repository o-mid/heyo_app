import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:reorderables/reorderables.dart';

class GroupCallWidget extends StatelessWidget {
  const GroupCallWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    final width = (context.width - (8.w * 3)) / 2;
    final height = width / 1.27;
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Padding(
          padding: EdgeInsets.only(
              bottom:
                  height), // This is for being able to scroll down to view the last two people in call
          child: ReorderableWrap(
            spacing: 8.w,
            runSpacing: 8.h,
            onReorder: controller.reorderParticipants,
            children: controller.participants
                .map(
                  // Todo: replace with actual video from call participants
                  (p) => Assets.png.groupCall.image(
                    width: width,
                    height: height,
                  ),
                )
                .toList(),
          ),
        ),
      );
    });
  }
}

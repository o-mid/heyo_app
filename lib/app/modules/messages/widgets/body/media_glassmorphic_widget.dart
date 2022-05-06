import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';

import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../controllers/messages_controller.dart';

class MediaGlassmorphic extends StatelessWidget {
  const MediaGlassmorphic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 50),
        reverseDuration: const Duration(milliseconds: 150),
        child: controller.isMediaGlassmorphicOpen.value
            ? Column(
                children: [
                  GlassmorphicContainer(
                    width: 296.w,
                    height: 176.h,
                    borderRadius: 8.r,
                    blur: 36,
                    border: 0,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF466087).withOpacity(0.05),
                        const Color(0xFF466087).withOpacity(0.05),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.mic_sharp)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                ],
              )
            : SizedBox(),
      );
    });
  }
}

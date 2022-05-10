import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../routes/app_pages.dart';
import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../shared/widgets/circular_media_icon_button.dart';
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
                    width: 290.w,
                    height: 156.h,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xffFFB500),
                              child: Assets.svg.cameraIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // camera onPressed:
                              onPressed: () async {
                                controller.pick(context);
                              },
                              padding: 18,
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff16B4F2),
                              child: Assets.svg.galleryIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // gallery onPressed:
                              onPressed: () {},
                              padding: 18,
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff7E3CF9),
                              child: Assets.svg.locationIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // location onPressed:
                              onPressed: () {},
                              padding: 18,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xffF93C53),
                              child: Assets.svg.fileIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // file onPressed:
                              onPressed: () {},
                              padding: 18,
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff00B4B5),
                              child: Assets.svg.moneyIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // money onPressed:
                              onPressed: () {},
                              padding: 18,
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff003EB5),
                              child: Assets.svg.personIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                              // person onPressed:
                              onPressed: () {},
                              padding: 18,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                ],
              )
            : const SizedBox(),
      );
    });
  }
}

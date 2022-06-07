import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';
import 'package:heyo/generated/assets.gen.dart';

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
                              // camera onPressed:
                              onPressed: () async {
                                controller.pick(context);
                              },
                              padding: 18,
                              child: Assets.svg.cameraIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff16B4F2),
                              onPressed: () => controller.openGallery(),
                              padding: 18,
                              child: Assets.svg.galleryIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff7E3CF9),
                              // location onPressed:
                              onPressed: () {
                                Get.toNamed(Routes.SHARE_LOCATION);
                              },
                              padding: 18,
                              child: Assets.svg.locationIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xffF93C53),
                              // file onPressed:
                              onPressed: () {
                                Get.toNamed(Routes.SHARE_FILES);
                              },
                              padding: 18,
                              child: Assets.svg.fileIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff00B4B5),
                              // money onPressed:
                              onPressed: () {},
                              padding: 18,
                              child: Assets.svg.moneyIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
                            ),
                            CircularMediaIconButton(
                              backgroundColor: const Color(0xff003EB5),
                              // person onPressed:
                              onPressed: () {},
                              padding: 18,
                              child: Assets.svg.personIcon.svg(
                                height: 20.w,
                                width: 20.w,
                              ),
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

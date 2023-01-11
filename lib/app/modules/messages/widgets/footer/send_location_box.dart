import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class SendLocationBox extends StatelessWidget {
  const SendLocationBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.locationMessage.value = null;
                },
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Assets.svg.target.svg(),
                ),
              ),
              CustomSizes.mediumSizedBoxWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.MessagesPage_sharedLocation.tr,
                      style: TEXTSTYLES.kChatText.copyWith(
                        color: COLORS.kDarkBlueColor,
                        fontWeight: FONTS.SemiBold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${controller.locationMessage.value?.latitude} ${controller.locationMessage.value?.longitude}",
                      style: TEXTSTYLES.kChatText.copyWith(
                        color: COLORS.kTextBlueColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CustomSizes.largeSizedBoxWidth,
              GestureDetector(
                onTap: () {
                  controller.sendLocationMessage();
                },
                child: Assets.svg.sendIcon.svg(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

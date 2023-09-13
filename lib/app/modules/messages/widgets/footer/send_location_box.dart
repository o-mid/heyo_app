import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_message_button.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../data/models/messages/location_message_model.dart';

class SendLocationBox extends StatelessWidget {
  const SendLocationBox({Key? key}) : super(key: key);

  String _getLocationText(LocationMessageModel? locationMessage) {
    return "${locationMessage?.latitude} ${locationMessage?.longitude}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  _getLocationText(controller.locationMessage.value),
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
          SendMessageButton(
            onTap: controller.sendLocationMessage,
          )
        ],
      ),
    );
  }
}

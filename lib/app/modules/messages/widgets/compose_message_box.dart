import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class ComposeMessageBox extends StatelessWidget {
  const ComposeMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return Row(
        children: [
          GestureDetector(
            // Todo: implement add media button
            onTap: () {},
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: COLORS.kGreenMainColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: COLORS.kWhiteColor,
                size: 16,
              ),
            ),
          ),
          CustomSizes.mediumSizedBoxWidth,
          Expanded(
            child: TextFormField(
              maxLines: 7,
              minLines: 1,
              onChanged: (msg) {
                controller.newMessage.value = msg;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: LocaleKeys.MessagesPage_textFieldHint.tr,
              ),
              controller: controller.textController,
            ),
          ),
          CustomSizes.largeSizedBoxWidth,
          KeyboardDismissOnTap(
            dismissOnCapturedTaps: true,
            child: GestureDetector(
              onTap: controller.toggleEmojiPicker,
              child: Assets.svg.emojiIcon.svg(color: COLORS.kDarkBlueColor),
            ),
          ),
          CustomSizes.largeSizedBoxWidth,
          if (controller.newMessage.isEmpty)
            // Todo: add gesture detection and implement record voice
            Assets.svg.recordIcon.svg(color: COLORS.kDarkBlueColor),
          if (controller.newMessage.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.sendTextMessage();
              },
              child: Assets.svg.sendIcon.svg(),
            ),
        ],
      );
    });
  }
}

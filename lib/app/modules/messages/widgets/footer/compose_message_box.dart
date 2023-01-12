import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_message_button.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../shared/utils/constants/textStyles.dart';
import '../../../shared/widgets/scale_animated_switcher.dart';

class ComposeMessageBox extends StatelessWidget {
  const ComposeMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: GestureDetector(
                    // Todo: implement add media button
                    onTap: () {
                      controller.mediaGlassmorphicChangeState();
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: COLORS.kGreenMainColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: COLORS.kWhiteColor,
                        size: 16,
                      ),
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
                    style: TEXTSTYLES.kBodyBasic.copyWith(
                      color: COLORS.kBlackColor,
                    ),
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: controller.newMessage.isNotEmpty
                      ? SendMessageButton(
                          onTap: () => controller.sendTextMessage(),
                          padding: const EdgeInsets.only(
                            right: 18,
                            top: 10,
                            bottom: 10,
                          ))
                      : GestureDetector(
                          onTap: () => controller.isInRecordMode.value = true,
                          child: Container(
                              padding: const EdgeInsets.only(right: 18),
                              child: Assets.svg.recordIcon.svg(color: COLORS.kDarkBlueColor)),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

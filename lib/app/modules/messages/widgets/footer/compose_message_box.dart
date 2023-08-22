import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/footer/record_button_widget.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_message_button.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../shared/utils/constants/textStyles.dart';
import '../../../shared/widgets/scale_animated_switcher.dart';
import 'compose_text_field_widget.dart';
import 'emoji_picker_button_widget.dart';
import 'media_glassmorphic_button_widget.dart';

class ComposeMessageBox extends StatelessWidget {
  const ComposeMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              MediaGlassmorphicButtonWidget(
                onTap: () {
                  controller.mediaGlassmorphicChangeState();
                },
              ),

              CustomSizes.smallSizedBoxWidth,
              const Expanded(
                child: ComposeTextFieldWidget(),
              ),
              //  CustomSizes.largeSizedBoxWidth,
              KeyboardDismissOnTap(
                dismissOnCapturedTaps: true,
                child: EmojiPickerButtonWidget(
                  onTap: controller.toggleEmojiPicker,
                ),
              ),

              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: controller.newMessage.isNotEmpty
                      ? SendMessageButton(
                          onTap: () => controller.sendTextMessage(),
                        )
                      : RecordButtonWidget(
                          onTap: () => controller.isInRecordMode.value = true,
                        ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/footer/compose_text_field_widget.dart';
import 'package:heyo/app/modules/messages/widgets/footer/emoji_picker_button_widget.dart';
import 'package:heyo/app/modules/messages/widgets/footer/media_glassmorphic_button_widget.dart';
import 'package:heyo/app/modules/messages/widgets/footer/record_button_widget.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_message_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

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

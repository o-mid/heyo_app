import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_location_box.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';

import '../../../shared/widgets/glassmorphic_container.dart';
import 'compose_message_box.dart';
import 'message_selection_options.dart';
import 'replying_to_widget.dart';
import 'voice_recorder/voice_recorder_widget.dart';

class MessagesFooter extends StatelessWidget {
  const MessagesFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return Column(
        children: [
          if (controller.replyingTo.value != null)
            ReplyingToWidget(
              clearReplyTo: controller.clearReplyTo,
              replyingTo: controller.replyingTo.value!,
            ),

          // Chat Text Field
          ScaleAnimatedSwitcher(
            child: controller.isInRecordMode.isTrue
                ? const VoiceRecorderWidget()
                : Container(
                    height: 90.h,
                    // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: COLORS.kComposeMessageBorderColor,
                        ),
                      ),
                    ),
                    child: ScaleAnimatedSwitcher(child: _buildActiveBox(controller)),
                  ),
          ),

          // Emoji Picker (Hidden by default)

          Offstage(
            offstage: !controller.showEmojiPicker.value,
            child: WillPopScope(
              onWillPop: () async {
                if (controller.showEmojiPicker.value) {
                  controller.showEmojiPicker.value = false;
                  FocusScope.of(context).requestFocus(controller.textFocusNode);

                  return false;
                }
                return true;
              },
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (_, Emoji emoji) =>
                      controller.appendAfterCursorPosition(emoji.emoji),
                  onBackspacePressed: controller.removeCharacterBeforeCursorPosition,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActiveBox(MessagesController controller) {
    if (controller.selectedMessages.isNotEmpty) {
      return MessageSelectionOptions(
        showReply: controller.selectedMessages.length == 1,
        showCopy: !controller.selectedMessages.any((m) => m is! TextMessageModel),
        selectedMessages: controller.selectedMessages,
      );
    }

    if (controller.locationMessage.value != null) {
      return const SendLocationBox();
    }

    return const ComposeMessageBox();
  }
}

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // Todo Appbar
        backgroundColor: COLORS.kAppBackground,
        body: Column(
          children: [
            SizedBox(height: 54),
            _buildMessagesHeader(),
            // Todo Messages
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text("$index"),
                  );
                },
              ),
            ),

            // Chat Text Field
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color(0xffF8F7FF),
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xffe9e7f0),
                  ),
                ),
              ),
              child: Row(
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
                  SizedBox(width: 18),
                  Expanded(
                    child: TextFormField(
                      maxLines: 7,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: LocaleKeys.MessagesPage_textFieldHint.tr,
                      ),
                      controller: controller.controller,
                    ),
                  ),
                  SizedBox(width: 26),
                  KeyboardDismissOnTap(
                    dismissOnCapturedTaps: true,
                    child: GestureDetector(
                      onTap: controller.toggleEmojiPicker,
                      child: Assets.svg.emojiIcon.svg(color: COLORS.kDarkBlueColor),
                    ),
                  ),
                  SizedBox(width: 22),
                  // Todo: add gesture detection and implement record voice
                  Assets.svg.recordIcon.svg(color: COLORS.kDarkBlueColor),
                ],
              ),
            ),
            Offstage(
              offstage: !controller.showEmojiPicker.value,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (_, Emoji emoji) =>
                      controller.appendAfterCursorPosition(emoji.emoji),
                  onBackspacePressed: controller.removeCharacterBeforeCursorPosition,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMessagesHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: COLORS.kPinCodeDeactivateColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomCircleAvatar(url: controller.args.chat.icon, size: 64),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.args.chat.name,
                style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
              ),
              SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: COLORS.kBlueColor,
                  shape: BoxShape.circle,
                ),
                child: Assets.svg.verified.svg(
                  color: COLORS.kWhiteColor,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          // Todo: show core id
          Text(
            "CB13...586A",
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
          ),
          SizedBox(height: 16),
          Text(
            LocaleKeys.MessagesPage_endToEndEncryptedMessaging.trParams(
              {"name": controller.args.chat.name},
            ),
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
          ),
        ],
      ),
    );
  }
}

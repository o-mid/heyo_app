import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
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
            // Todo Messages
            Expanded(
              child: ListView.builder(
                itemCount: 50,
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
                    // Todo
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
                  GestureDetector(
                    onTap: controller.toggleEmojiPicker,
                    child: Assets.svg.emojiIcon.svg(color: COLORS.kDarkBlueColor),
                  ),
                  SizedBox(width: 22),
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
}

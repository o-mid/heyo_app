import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/widgets/message_from_me_widget.dart';
import 'package:heyo/app/modules/messages/widgets/message_from_other_widget.dart';
import 'package:heyo/app/modules/messages/widgets/message_selection_options.dart';
import 'package:heyo/app/modules/messages/widgets/messaging_app_bar.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // Todo Appbar
        appBar: MessagingAppBar(chat: controller.args.chat),
        backgroundColor: COLORS.kAppBackground,
        body: Column(
          children: [
            Expanded(
              child: ScrollablePositionedList.builder(
                padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
                itemScrollController: controller.scrollController,
                reverse: true,
                itemCount: controller.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) return _buildMessagesHeader();

                  final message = controller.messages[index];
                  final prevMessage = index == controller.messages.length - 1
                      ? null
                      : controller.messages[index + 1];

                  final children = <Widget>[];

                  // Adds date header at beginning of new messages in a certain date
                  if (prevMessage == null || !prevMessage.timestamp.isSameDate(message.timestamp)) {
                    children.addAll([
                      CustomSizes.mediumSizedBoxHeight,
                      Text(
                        message.timestamp.differenceFromNow(),
                        style: TEXTSTYLES.kBodyTag.copyWith(
                          color: COLORS.kTextBlueColor,
                          fontSize: 10.sp,
                        ),
                      ),
                      CustomSizes.mediumSizedBoxHeight,
                    ]);
                  }
                  if (message.isFromMe) {
                    children.add(MessageFromMeWidget(message: message));
                  } else {
                    children.add(
                      MessageFromOtherWidget(
                        message: message,
                        showTimeAndProfile: true,
                        // showTimeAndProfile: index == controller.messages.length - 1 ||
                        //     controller.messages[index + 1].senderName != message.senderName,
                      ),
                    );
                  }

                  return GestureDetector(
                    onLongPress: () => controller.toggleMessageSelection(message.messageId),
                    onTap: controller.selectedMessages.isEmpty
                        ? null
                        : () => controller.toggleMessageSelection(message.messageId),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          color:
                              message.isSelected ? COLORS.kGreenLighterColor : Colors.transparent,
                          child: Column(
                            children: children,
                          ),
                        ),
                        if (message.isSelected)
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: Container(
                              color: COLORS.kGreenMainColor,
                              width: 3,
                            ),
                          )
                      ],
                    ),
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
              // Todo: animate switching between options and text field
              child: controller.selectedMessages.length > 0
                  ? MessageSelectionOptions(
                      showReply: controller.selectedMessages.length == 1,
                      // Todo: add flags for copy and forward
                    )
                  : Row(
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
      margin: EdgeInsets.all(16.w).copyWith(top: 0, bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
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
          CustomSizes.mediumSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.args.chat.name,
                style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
              ),
              CustomSizes.smallSizedBoxWidth,
              Container(
                width: 24.w,
                height: 24.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: COLORS.kBlueColor,
                  shape: BoxShape.circle,
                ),
                child: Assets.svg.verified.svg(
                  color: COLORS.kWhiteColor,
                  // fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Todo: show core id
          Text(
            "CB13...586A",
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
          ),
          CustomSizes.mediumSizedBoxHeight,
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

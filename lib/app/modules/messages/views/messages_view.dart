import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/beginning_of_messages_header.dart';
import 'package:heyo/app/modules/messages/widgets/compose_message_box.dart';
import 'package:heyo/app/modules/messages/widgets/message_selection_options.dart';
import 'package:heyo/app/modules/messages/widgets/message_selection_wrapper.dart';
import 'package:heyo/app/modules/messages/widgets/messaging_app_bar.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  final _messageAndReplyBoxDecoration = const BoxDecoration(
    color: COLORS.kComposeMessageBackgroundColor,
    border: Border(
      top: BorderSide(
        width: 1,
        color: COLORS.kComposeMessageBorderColor,
      ),
    ),
  );

  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: MessagingAppBar(chat: controller.args.chat),
        backgroundColor: COLORS.kAppBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
                itemCount: controller.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return BeginningOfMessagesHeader(
                      chat: controller.args.chat,
                    );
                  }

                  final message = controller.messages[index - 1];
                  final prevMessage =
                      index == 1 ? null : controller.messages[index - 2];

                  // Adds date header at beginning of new messages in a certain date
                  var dateHeaderWidgets = <Widget>[];
                  if (prevMessage == null ||
                      !prevMessage.timestamp.isSameDate(message.timestamp)) {
                    dateHeaderWidgets = [
                      CustomSizes.mediumSizedBoxHeight,
                      Text(
                        message.timestamp.differenceFromNow(),
                        style: TEXTSTYLES.kBodyTag.copyWith(
                          color: COLORS.kTextBlueColor,
                          fontSize: 10.sp,
                        ),
                      ),
                      CustomSizes.mediumSizedBoxHeight,
                    ];
                  }

                  return AutoScrollTag(
                    key: Key(index.toString()),
                    index: index,
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        ...dateHeaderWidgets,
                        MessageSelectionWrapper(
                          message: message,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (controller.replyingTo.value != null)
              Container(
                decoration: _messageAndReplyBoxDecoration,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: controller.clearReplyTo,
                      child: Assets.svg.replyOutlined.svg(
                        width: 19.w,
                        height: 17.w,
                        color: COLORS.kDarkBlueColor,
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.MessagesPage_replyingTo.trParams({
                              "name":
                                  controller.replyingTo.value!.repliedToName,
                            }),
                            style: TEXTSTYLES.kChatText.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.SemiBold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            controller.replyingTo.value!.repliedToMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TEXTSTYLES.kChatText
                                .copyWith(color: COLORS.kTextBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Chat Text Field
            Container(
              constraints: BoxConstraints(minHeight: 90.h),
              padding: EdgeInsets.all(18),
              decoration: _messageAndReplyBoxDecoration,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: controller.selectedMessages.isNotEmpty
                    ? MessageSelectionOptions(
                        showReply: controller.selectedMessages.length == 1,
                        showCopy: !controller.selectedMessages
                            .any((m) => m is! TextMessageModel),
                        selectedMessages: controller.selectedMessages,
                        // Todo: add flag and forward
                      )
                    : const ComposeMessageBox(),
              ),
            ),
            Offstage(
              offstage: !controller.showEmojiPicker.value,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (_, Emoji emoji) =>
                      controller.appendAfterCursorPosition(emoji.emoji),
                  onBackspacePressed:
                      controller.removeCharacterBeforeCursorPosition,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

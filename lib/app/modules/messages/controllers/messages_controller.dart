import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessagesController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ItemScrollController();
  final showEmojiPicker = false.obs;
  final messages = <MessageModel>[].obs;
  late MessagesViewArgumentsModel args;

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as MessagesViewArgumentsModel;

    _addMockData();

    // Close emoji picker when keyboard opens
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        showEmojiPicker.value = false;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  void appendAfterCursorPosition(String str) {
    final currentPos = textController.selection.base.offset;

    textController.text = textController.text.substring(0, currentPos) +
        str +
        textController.text.substring(currentPos);

    textController.selection = textController.selection
        .copyWith(baseOffset: currentPos + str.length, extentOffset: currentPos + str.length);
  }

  void removeCharacterBeforeCursorPosition() {
    final currentPos = textController.selection.base.offset;
    final prefix = textController.text.substring(0, currentPos).characters.skipLast(1).toString();
    final suffix = textController.text.substring(currentPos);

    textController.text = prefix + suffix;
    textController.selection = textController.selection.copyWith(
      baseOffset: prefix.length,
      extentOffset: prefix.length,
    );
  }

  void scrollToMessage(String id) {
    final index = messages.value.indexWhere((m) => m.messageId == id);
    if (index >= 0) {
      scrollController.scrollTo(index: index, duration: Duration(milliseconds: 500));
    } else {
      // Todo: implement loading replied message and scrolling to it
    }
  }

  void _addMockData() {
    var index = 0;
    messages.addAll([
      MessageModel(
        messageId: "${index++}",
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 5, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),

      //
      MessageModel(
        messageId: "${index++}",
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),

      //
      MessageModel(
        messageId: "${index++}",
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Sure thing. Just let me know when sth happens",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 56)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Very nice!",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 55)),
        senderName: "",
        senderAvatar: "",
        replyTo: ReplyToModel(
          repliedToMessageId: "${index - 2}",
          repliedToMessage: "Sure thing. Just let me know when sth happens",
          repliedToName: args.chat.name,
        ),
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Very nice!",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 54)),
        senderName: "",
        senderAvatar: "",
        replyTo: ReplyToModel(
          repliedToMessageId: "0",
          repliedToMessage:
              "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
          repliedToName: args.chat.name,
        ),
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
    ]);

    messages.value
        .sort((a, b) => b.timestamp.millisecondsSinceEpoch - a.timestamp.millisecondsSinceEpoch);
  }
}

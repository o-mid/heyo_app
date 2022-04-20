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
  final selectedMessages = <MessageModel>[].obs;
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

  void toggleReaction(MessageModel msg, String emoji) {
    final index = messages.value.indexWhere((m) => m.messageId == msg.messageId);
    if (index < 0) {
      return;
    }

    final message = messages.value[index];
    var reaction = message.reactions.putIfAbsent(emoji, () => ReactionModel());

    if (reaction.isReactedByMe) {
      // Todo: remove user core id from list
      reaction.users.removeLast();
    } else {
      // Todo: add user core id
      reaction = reaction.copyWith(users: [...reaction.users, ""]);
    }
    reaction = reaction.copyWith(
      isReactedByMe: !reaction.isReactedByMe,
    );
    message.reactions.update(emoji, (r) => reaction);

    messages.refresh();

    // Todo: send updated reactions with libp2p
  }

  void toggleMessageSelection(String id) {
    final index = messages.value.indexWhere((m) => m.messageId == id);

    if (index < 0) {
      return;
    }

    final message = messages.value[index];
    if (message.isSelected) {
      selectedMessages.value.removeWhere((m) => m.messageId == id);
    } else {
      selectedMessages.value.add(message);
    }
    messages.value[index] = message.copyWith(isSelected: !message.isSelected);
    messages.refresh();
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
        reactions: {
          "🎉": ReactionModel(
            users: List.generate(12, (index) => ""),
          ),
          "🤘": ReactionModel(
            users: List.generate(3, (index) => ""),
            isReactedByMe: true,
          ),
          "🔥": ReactionModel(
            users: List.generate(5, (index) => ""),
          ),
          "👍": ReactionModel(
            users: List.generate(2, (index) => ""),
          ),
          "😎": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
        },
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
        reactions: {
          "🤗": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
          "😘": ReactionModel(
            users: List.generate(2, (index) => ""),
            isReactedByMe: true,
          ),
        },
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
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 52)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.SENT,
      ),
      MessageModel(
        messageId: "${index++}",
        type: CONTENT_TYPE.IMAGE,
        payload:
            "https://images.unsplash.com/photo-1623128358746-bf4c6cf92bc3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        replyTo: ReplyToModel(
          repliedToMessageId: "0",
          repliedToMessage:
              "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
          repliedToName: args.chat.name,
        ),
      ),
      MessageModel(
        messageId: "${index++}",
        type: CONTENT_TYPE.IMAGE,
        payload:
            "https://images.unsplash.com/photo-1533282960533-51328aa49826?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2142&q=80",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 49)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
        reactions: {
          "🤗": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
          "😘": ReactionModel(
            users: List.generate(2, (index) => ""),
            isReactedByMe: true,
          ),
        },
      ),
    ]);

    messages.value
        .sort((a, b) => b.timestamp.millisecondsSinceEpoch - a.timestamp.millisecondsSinceEpoch);
  }
}

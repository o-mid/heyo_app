import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/message_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/widgets/delete_message_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MessagesController extends GetxController {
  final textController = TextEditingController();
  final scrollController = AutoScrollController();
  final newMessage = "".obs;
  final showEmojiPicker = false.obs;
  final messages = <MessageModel>[].obs;
  final selectedMessages = <MessageModel>[].obs;
  final replyingTo = Rxn<ReplyToModel>();
  late MessagesViewArgumentsModel args;

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as MessagesViewArgumentsModel;

    _addMockData();
    // int lastMessageIndex = messages.indexOf(messages.last);
    // if (args.forwardedMessages != null) {
    //   args.forwardedMessages?.forEach((message) {
    //     messages.add(MessageModel(
    //       messageId: "${lastMessageIndex++}",
    //       payload: message.payload,
    //       timestamp: message.timestamp,
    //       senderName: message.senderName,
    //       senderAvatar: message.senderAvatar,
    //     ));
    //   });
    // }

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
    jumpToBottom();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  void appendAfterCursorPosition(String str) {
    final currentPos = textController.selection.base.offset;

    textController.text = textController.text.substring(0, currentPos) +
        str +
        textController.text.substring(currentPos);

    textController.selection = textController.selection.copyWith(
        baseOffset: currentPos + str.length,
        extentOffset: currentPos + str.length);
  }

  void removeCharacterBeforeCursorPosition() {
    final currentPos = textController.selection.base.offset;
    final prefix = textController.text
        .substring(0, currentPos)
        .characters
        .skipLast(1)
        .toString();
    final suffix = textController.text.substring(currentPos);

    textController.text = prefix + suffix;
    textController.selection = textController.selection.copyWith(
      baseOffset: prefix.length,
      extentOffset: prefix.length,
    );
  }

  void scrollToMessage(String id) {
    final index = messages.indexWhere((m) => m.messageId == id);
    if (index >= 0) {
      scrollController.scrollToIndex(
        index,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      // Todo: implement loading replied message and scrolling to it
    }
  }

  void jumpToBottom() {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  void toggleReaction(MessageModel msg, String emoji) {
    final index = messages.indexWhere((m) => m.messageId == msg.messageId);
    if (index < 0) {
      return;
    }

    final message = messages[index];
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
    final index = messages.indexWhere((m) => m.messageId == id);

    if (index < 0) {
      return;
    }

    final message = messages[index];
    if (message.isSelected) {
      selectedMessages.removeWhere((m) => m.messageId == id);
    } else {
      selectedMessages.add(message);
    }
    messages[index] = message.copyWith(isSelected: !message.isSelected);
    messages.refresh();
  }

  void clearSelected() {
    messages.setAll(0, messages.map((m) => m.copyWith(isSelected: false)));
    selectedMessages.clear();
  }

  void sendTextMessage() {
    var message = MessageModel(
      // Todo: Generate random id
      messageId: messages.length.toString(),
      payload: newMessage.value,
      timestamp: DateTime.now().toUtc(),
      replyTo: replyingTo.value,
      // Todo: fill with user info
      senderName: "",
      senderAvatar: "",
      isFromMe: true,
    );

    // Todo: change status once message was successfully sent
    message = message.copyWith(status: MESSAGE_STATUS.SENT);

    // Todo: send message with libp2p.

    messages.add(message);
    textController.clear();

    clearReplyTo();

    jumpToBottom();
  }

  void replyTo() {
    if (selectedMessages.length != 1) return;
    final msg = selectedMessages.first;

    late String replyMsg;
    switch (msg.type) {
      case CONTENT_TYPE.TEXT:
        replyMsg = msg.payload;
        break;
      case CONTENT_TYPE.IMAGE:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
      case CONTENT_TYPE.VIDEO:
        // Todo: use video metadata to show video duration
        replyMsg = LocaleKeys.MessagesPage_replyToVideo.tr;
        break;
      case CONTENT_TYPE.AUDIO:
        // Todo: use video metadata to show audio duration
        replyMsg = LocaleKeys.MessagesPage_replyToAudio.tr;
    }

    replyingTo.value = ReplyToModel(
      repliedToMessageId: msg.messageId,
      repliedToName: msg.senderName,
      repliedToMessage: replyMsg,
    );

    clearSelected();
  }

  void clearReplyTo() {
    replyingTo.value = null;
  }

  void showDeleteSelectedDialog() {
    Get.dialog(
      DeleteMessageDialog(
        canDeleteForEveryone: canDeleteForEveryone(),
        deleteForEveryone: deleteSelectedForEveryone,
        deleteForMe: deleteSelectedForMe,
        toDeleteCount: selectedMessages.length,
      ),
    );
  }

  bool canDeleteForEveryone() {
    // If any selected messages belong to another user, it's not possible to delete for everyone
    return !selectedMessages.any((msg) => !msg.isFromMe);
  }

  void deleteSelectedForEveryone() {
    // Todo: update status of messages instead of removing from list
    for (var toDelete in selectedMessages) {
      messages.removeWhere((msg) => msg.messageId == toDelete.messageId);
      // Todo: libp2p - delete for others
    }
    clearSelected();
  }

  void deleteSelectedForMe() {
    for (var toDelete in selectedMessages) {
      messages.removeWhere((msg) => msg.messageId == toDelete.messageId);
    }
    clearSelected();
  }

  void copySelectedToClipboard() {
    var text = "";

    if (selectedMessages.length == 1) {
      text = selectedMessages.first.payload;
    } else {
      for (var message in selectedMessages) {
        text +=
            "[${message.senderName} - ${message.timestamp.dateInAmPmFormat()}]\n";
        text += message.payload;
        text += "\n\n";
      }
    }

    Clipboard.setData(
      ClipboardData(text: text),
    );

    clearSelected();
  }

  void _addMockData() {
    var index = 0;
    messages.addAll([
      MessageModel(
        messageId: "${index++}",
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 3, hours: 5, minutes: 58)),
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
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 1, minutes: 58)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: " Nihil, incidunt!",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Lorem ipsum dolor sit.",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        payload: "Sure thing. Just let me know when sth happens",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 56)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 54)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 52)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
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
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
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
      MessageModel(
        messageId: "${index++}",
        type: CONTENT_TYPE.VIDEO,
        payload:
            "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 47)),
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
      MessageModel(
        messageId: "${index++}",
        type: CONTENT_TYPE.AUDIO,
        metadata: AudioMetadata(durationInSeconds: 100),
        payload:
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 46)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        messageId: "${index++}",
        type: CONTENT_TYPE.AUDIO,
        metadata: AudioMetadata(durationInSeconds: 19),
        payload: "https://download.samplelib.com/mp3/sample-15s.mp3",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
    ]);

    messages.sort((a, b) =>
        a.timestamp.millisecondsSinceEpoch -
        b.timestamp.millisecondsSinceEpoch);
  }
}

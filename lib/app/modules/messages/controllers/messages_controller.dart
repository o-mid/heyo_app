import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/widgets/delete_message_dialog.dart';
import 'package:heyo/app/modules/shared/data/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/data/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MessagesController extends GetxController {
  final textController = TextEditingController();
  final scrollController = AutoScrollController();
  final newMessage = "".obs;
  final showEmojiPicker = false.obs;
  final isInRecordMode = false.obs;
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
    //     messages.add(MessageModel(text: text, messageId: messageId, timestamp: timestamp, senderName: senderName, senderAvatar: senderAvatar)(
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

    // Todo: remove this when a global player is implemented
    Get.find<AudioMessageController>().player.stop();

    Get.find<VideoMessageController>().stopAndClearPreviousVideo();
  }

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
    var message = TextMessageModel(
      // Todo: Generate random id
      messageId: messages.length.toString(),
      text: newMessage.value,
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
    newMessage.value = "";

    clearReplyTo();

    jumpToBottom();
  }

  void sendAudioMessage(String path, int duration) {
    final message = AudioMessageModel(
      url: "",
      localUrl: path,
      metadata: AudioMetadata(durationInSeconds: duration),
      messageId: messages.length.toString(), // Todo
      timestamp: DateTime.now(),
      senderName: "",
      senderAvatar: "",
      isFromMe: true,
    );

    // Todo: upload file to decentralized storage and save the url
    // Todo (libp2p): send message with libp2p

    messages.add(message);

    messages.refresh();
  }

  void replyTo() {
    if (selectedMessages.length != 1) return;
    final msg = selectedMessages.first;

    late String replyMsg;
    switch (msg.runtimeType) {
      case TextMessageModel:
        replyMsg = (msg as TextMessageModel).text;
        break;
      case ImageMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
      case VideoMessageModel:
        // Todo: use video metadata to show video duration
        replyMsg = LocaleKeys.MessagesPage_replyToVideo.tr;
        break;
      case AudioMessageModel:
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

    if (selectedMessages.length == 1 && selectedMessages.first is TextMessageModel) {
      text = (selectedMessages.first as TextMessageModel).text;
    } else {
      for (var message in selectedMessages) {
        if (message is! TextMessageModel) {
          continue;
        }

        text += "[${message.senderName} - ${message.timestamp.dateInAmPmFormat()}]\n";
        text += message.text;
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
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 5, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        status: MESSAGE_STATUS.READ,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Sure thing. Just let me know when sth happens",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 56)),
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
      TextMessageModel(
        messageId: "${index++}",
        text: "Very nice!",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
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
      TextMessageModel(
        messageId: "${index++}",
        text: "Very nice!",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 54)),
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
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 52)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.SENT,
      ),
      ImageMessageModel(
        messageId: "${index++}",
        url:
            "https://images.unsplash.com/photo-1623128358746-bf4c6cf92bc3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        replyTo: ReplyToModel(
          repliedToMessageId: "0",
          repliedToMessage:
              "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
          repliedToName: args.chat.name,
        ),
      ),
      ImageMessageModel(
        messageId: "${index++}",
        url:
            "https://images.unsplash.com/photo-1533282960533-51328aa49826?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2142&q=80",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
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
      VideoMessageModel(
        messageId: "${index++}",
        url:
            "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
        metadata: VideoMetadata(
          durationInSeconds: 120,
          thumbnailUrl:
              "https://images.unsplash.com/photo-1623128358746-bf4c6cf92bc3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
        ),
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 47)),
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
      VideoMessageModel(
        messageId: "${index++}",
        url:
            "https://assets.mixkit.co/videos/download/mixkit-microchip-technology-close-up-1140.mp4",
        metadata: VideoMetadata(
          durationInSeconds: 120,
          thumbnailUrl: "https://mixkit.imgix.net/static/home/video-thumb3.png",
        ),
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 47)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      AudioMessageModel(
        messageId: "${index++}",
        metadata: AudioMetadata(durationInSeconds: 100),
        url: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 46)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      AudioMessageModel(
        messageId: "${index++}",
        metadata: AudioMetadata(durationInSeconds: 19),
        url: "https://download.samplelib.com/mp3/sample-15s.mp3",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
    ]);

    messages
        .sort((a, b) => a.timestamp.millisecondsSinceEpoch - b.timestamp.millisecondsSinceEpoch);
  }
}

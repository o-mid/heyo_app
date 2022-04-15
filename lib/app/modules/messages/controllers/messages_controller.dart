import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';

class MessagesController extends GetxController {
  final controller = TextEditingController();
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
    final currentPos = controller.selection.base.offset;

    controller.text =
        controller.text.substring(0, currentPos) + str + controller.text.substring(currentPos);

    controller.selection = controller.selection
        .copyWith(baseOffset: currentPos + str.length, extentOffset: currentPos + str.length);
  }

  void removeCharacterBeforeCursorPosition() {
    final currentPos = controller.selection.base.offset;
    final prefix = controller.text.substring(0, currentPos).characters.skipLast(1).toString();
    final suffix = controller.text.substring(currentPos);

    controller.text = prefix + suffix;
    controller.selection = controller.selection.copyWith(
      baseOffset: prefix.length,
      extentOffset: prefix.length,
    );
  }

  void _addMockData() {
    messages.addAll([
      MessageModel(
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
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
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),
      MessageModel(
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.READ,
      ),

      //
      MessageModel(
        payload:
            "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 5)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 4)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 3)),
        senderName: args.chat.name,
        senderAvatar: args.chat.icon,
      ),
      MessageModel(
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.SENT,
      ),
      MessageModel(
        payload: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MESSAGE_STATUS.SENT,
      ),
    ]);

    messages.value
        .sort((a, b) => b.timestamp.millisecondsSinceEpoch - a.timestamp.millisecondsSinceEpoch);
  }
}

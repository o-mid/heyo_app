import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';

class MessagesController extends GetxController {
  final controller = TextEditingController();
  final showEmojiPicker = false.obs;
  late MessagesViewArgumentsModel args;

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as MessagesViewArgumentsModel;

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
}

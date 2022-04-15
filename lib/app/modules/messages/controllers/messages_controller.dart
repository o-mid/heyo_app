import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final controller = TextEditingController();
  final showEmojiPicker = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
    print(showEmojiPicker.value);
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

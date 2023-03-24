import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import 'package:heyo/generated/locales.g.dart';

import '../../../shared/utils/constants/textStyles.dart';

class ComposeTextFieldWidget extends StatelessWidget {
  const ComposeTextFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return TextFormField(
      maxLines: 7,
      minLines: 1,
      //  expands: true,
      onChanged: (msg) => controller.newMessage.value = msg,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: LocaleKeys.MessagesPage_textFieldHint.tr,
      ),
      controller: controller.textController,
      style: TEXTSTYLES.kBodyBasic.copyWith(
        color: COLORS.kBlackColor,
      ),

      focusNode: controller.textFocusNode,
    );
  }
}

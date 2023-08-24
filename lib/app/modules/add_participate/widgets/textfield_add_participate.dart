import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/utils/screen-utils/inputs/custom_text_field.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../controllers/add_participate_controller.dart';

class TextfieldAddParticipate extends StatelessWidget {
  final AddParticipateController controller;
  const TextfieldAddParticipate(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CustomSizes.mainContentPadding,
      child: FocusScope(
        child: Focus(
          onFocusChange: (focus) => controller.isTextInputFocused.value = focus,
          focusNode: controller.inputFocusNode,
          child: CUSTOMTEXTFIELD(
            autofocus: true,
            textController: controller.inputController,
            labelText: LocaleKeys.newChat_usernameInput.tr,
          ),
        ),
      ),
    );
  }
}

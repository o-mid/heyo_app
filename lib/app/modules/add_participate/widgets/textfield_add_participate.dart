import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/locales.g.dart';

class TextfieldAddParticipate extends GetView<AddParticipateController> {
  const TextfieldAddParticipate({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CustomSizes.mainContentPadding,
      child: CustomTextField(
        //autofocus: true,
        textController: controller.inputController,
        labelText: LocaleKeys.newChat_usernameInput.tr,
        onChanged: (query) => controller.searchUsers(query),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
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
        //textController: controller.inputController.value,
        labelText: LocaleKeys.newChat_usernameInput.tr,
        onChanged: (query) => controller.searchUsers(query),
        rightWidget: IconButton(
          icon: const Icon(
            Icons.qr_code_rounded,
            color: COLORS.kDarkBlueColor,
            size: 24,
          ),
          onPressed: controller.qrBottomSheet,
        ),
      ),
    );
  }
}

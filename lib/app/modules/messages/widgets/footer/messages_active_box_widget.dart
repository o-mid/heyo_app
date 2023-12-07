import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/footer/send_location_box.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import '../../../shared/widgets/scale_animated_switcher.dart';
import '../../data/models/messages/text_message_model.dart';
import 'compose_message_box.dart';
import 'message_selection_options.dart';

class MessagesActiveBoxWidget extends StatelessWidget {
  const MessagesActiveBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    Widget activeBoxWidget() {
      return Obx(
        () {
          if (controller.selectedMessages.isNotEmpty) {
            return MessageSelectionOptions(
              showReply: controller.selectedMessages.length == 1,
              showCopy: !controller.selectedMessages.any((m) => m is! TextMessageModel),
              selectedMessages: controller.selectedMessages,
            );
          } else if (controller.locationMessage.value != null) {
            return const SendLocationBox();
          } else {
            return const ComposeMessageBox();
          }
        },
      );
    }

    return SafeArea(
      child: Container(
        height: 56,
        // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: COLORS.kComposeMessageBorderColor,
            ),
          ),
        ),
        child: ScaleAnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: activeBoxWidget(),
        ),
      ),
    );
  }
}

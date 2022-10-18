import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/widgets/app_bar/messaging_app_bar.dart';
import 'package:heyo/app/modules/messages/widgets/body/media_glassmorphic_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/messages_list.dart';
import 'package:heyo/app/modules/messages/widgets/footer/messages_footer.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Should be in a delete
      // need to not getting Not used any observable in this file error
      if (kDebugMode) {
        print(controller.isInRecordMode);
      }
      return Scaffold(
        appBar: MessagingAppBar(chat: controller.args.user.chatModel),
        backgroundColor: COLORS.kAppBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  MessagesList(),
                  Positioned(
                    bottom: 0,
                    child: MediaGlassmorphic(),
                  ),
                ],
              ),
            ),
            const MessagesFooter(),
          ],
        ),
      );
    });
  }
}

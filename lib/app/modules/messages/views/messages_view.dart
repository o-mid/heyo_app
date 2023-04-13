import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/widgets/app_bar/messaging_app_bar.dart';
import 'package:heyo/app/modules/messages/widgets/body/media_glassmorphic_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/messages_list.dart';
import 'package:heyo/app/modules/messages/widgets/footer/messages_footer.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import '../../messaging/widgets/datachannel_connection_status.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../controllers/messages_controller.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MessagingAppBar(),
      backgroundColor: COLORS.kAppBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DatachannelConnectionStatusWidget(),
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
    return Obx(() {
      // Should be in a delete
      // need to not getting Not used any observable in this file error
      if (kDebugMode) {
        print(controller.isInRecordMode);
      }
      return Scaffold(
        appBar: MessagingAppBar(userModel: controller.args.user),
        backgroundColor: COLORS.kAppBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConnectionStatusWidget(),
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

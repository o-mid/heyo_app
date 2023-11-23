import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';

import '../../data/models/messages/message_model.dart';
import 'beginning_of_messages_header_widget.dart';
import 'message_item_widget.dart';
import 'messages_list_view_widget.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    // ignore: require_trailing_commas
    return GestureDetector(

        // when the media Media Glassmorphic is Open tap on the rest of the screen will close it
        onTap: controller.closeMediaGlassmorphic,
        child: const MessagesListViewWidget());
  }
}

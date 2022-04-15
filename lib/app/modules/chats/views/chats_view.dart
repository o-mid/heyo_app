import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';
import 'package:heyo/app/modules/chats/widgets/empty_chats_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _buildChats(controller.chats.value),
      ),
    );
  }

  Widget _buildChats(List<ChatModel> chats) {
    return chats.length == 0
        ? EmptyChatsWidget()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Get.toNamed(Routes.MESSAGES);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: ChatWidget(chat: chats[index]),
                ),
              );
            },
          );
  }
}

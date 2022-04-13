import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';

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
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
          child: ChatWidget(chat: chats[index]),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';
import 'package:heyo/app/modules/chats/widgets/empty_chats_widget.dart';
import 'package:heyo/app/modules/shared/data/models/MessagesViewArgumentsModel.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.HomePage_navbarItems_chats.tr,
          style: TEXTSTYLES.kHeaderLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => _buildChats(controller.chats),
      ),
    );
  }

  Widget _buildChats(List<ChatModel> chats) {
    return chats.isEmpty
        ? const EmptyChatsWidget()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Get.toNamed(
                    Routes.MESSAGES,
                    arguments: MessagesViewArgumentsModel(chat: chats[index]),
                  );
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

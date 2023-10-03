import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';
import 'package:heyo/app/modules/chats/widgets/empty_chats_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/connection_status.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(
        title: LocaleKeys.HomePage_navbarItems_chats.tr,
        actions: [
          Obx(() {
            if (controller.chats.isNotEmpty) {
              return IconButton(
                splashRadius: 18,
                onPressed: controller.showDeleteAllChatsBottomSheet,
                icon: Assets.svg.verticalMenuIcon.svg(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConnectionStatusWidget(),
          Expanded(
            child: Obx(
              () => _buildChats(controller.chats),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChats(List<ChatModel> chats) {
    return chats.isEmpty
        ? const EmptyChatsWidget()
        : SlidableAutoCloseBehavior(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatWidget(chat: chats[index]);
              },
            ),
          );
  }
}

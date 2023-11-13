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
    controller.onChatsUpdated = (removed, added) {
      for (var chat in added) {
        final index = controller.chats.length;

        controller.animatedListKey.currentState?.insertItem(index);
        controller.chats.insert(index, chat);
      }
      for (var chat in removed) {
        final index = controller.chats.indexOf(chat);

        controller.animatedListKey.currentState?.removeItem(
          index,
          (context, animation) => _buildRemovedItem(chat, context, animation),
          duration: const Duration(milliseconds: 300),
        );
        controller.chats.removeAt(index);
      }

      controller.chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    };
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
              () => controller.chats.isEmpty
                  ? const EmptyChatsWidget()
                  : SlidableAutoCloseBehavior(
                      child: AnimatedList(
                        key: controller.animatedListKey,
                        initialItemCount: controller.chats.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween(begin: Offset(1, 0), end: Offset(0, 0))
                                  .chain(CurveTween(curve: Curves.easeInOut)),
                            ),
                            child: ChatWidget(chat: controller.chats[index]),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRemovedItem(ChatModel chat, BuildContext context, Animation<double> animation) {
  return SizeTransition(
    sizeFactor: animation,
    child: ChatWidget(
      chat: chat,
    ),
  );
}

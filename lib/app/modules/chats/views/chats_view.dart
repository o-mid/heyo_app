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
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.onChatsUpdated = _handleChatsUpdate;

    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConnectionStatusWidget(),
        _chatsList(),
      ],
    );
  }

  Widget _chatsList() {
    return Expanded(
      child: Obx(
        () => controller.chats.isEmpty ? const EmptyChatsWidget() : _buildAnimatedList(),
      ),
    );
  }

  Widget _buildAnimatedList() {
    return SlidableAutoCloseBehavior(
      child: AnimatedList(
          key: controller.animatedListKey,
          initialItemCount: controller.chats.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index, animation) => SlideTransition(
                position: _slideAnimation(animation),
                child: ChatWidget(chat: controller.chats[index]),
              )),
    );
  }

  Animation<Offset> _slideAnimation(Animation<double> animation) {
    return animation.drive(
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
          .chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  AppBarWidget _buildAppBar() {
    return AppBarWidget(
      title: LocaleKeys.HomePage_navbarItems_chats.tr,
      actions: [
        Obx(
          () => controller.chats.isNotEmpty
              ? IconButton(
                  splashRadius: 18,
                  onPressed: controller.showDeleteAllChatsBottomSheet,
                  icon: Assets.svg.verticalMenuIcon.svg(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _handleChatsUpdate(List<ChatModel> removed, List<ChatModel> added) {
    _addNewChats(added);
    _removeChats(removed);
    controller.chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void _addNewChats(List<ChatModel> added) {
    for (final chat in added) {
      final index = controller.chats.length;
      controller.animatedListKey.currentState?.insertItem(
        index,
        duration: const Duration(milliseconds: 200),
      );
      controller.chats.insert(index, chat);
    }
  }

  void _removeChats(List<ChatModel> removed) {
    for (final chat in removed) {
      final index = controller.chats.indexOf(chat);
      controller.animatedListKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedItem(chat, animation),
        duration: const Duration(milliseconds: 200),
      );
      controller.chats.removeAt(index);
    }
  }

  Widget _buildRemovedItem(ChatModel chat, Animation<double> animation) {
    return SlideTransition(
      position: _slideAnimation(animation),
      child: ChatWidget(chat: chat),
    );
  }
}

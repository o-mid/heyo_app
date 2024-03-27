import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:heyo/modules/features/chats/presentation/controllers/chats_controller.dart';

import 'package:heyo/modules/features/chats/presentation/widgets/chat_widget.dart';
import 'package:heyo/app/modules/chats/widgets/empty_chats_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/connection_status.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/modules/chats/data/models/chat_view_model/chat_view_model.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsNotifierProvider);
    final controller = ref.read(chatsNotifierProvider.notifier);
    // controller.onChatsUpdated = _handleChatsUpdate;

    void _addNewChats(List<ChatViewModel> added) {
      for (final chat in added) {
        final index = controller.chats.length;
        controller.animatedListKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 200),
        );
        controller.chats.insert(index, chat);
      }
    }

    void _removeChats(List<ChatViewModel> removed) {
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

    void _handleChatsUpdate(List<ChatViewModel> removed, List<ChatViewModel> added) {
      _addNewChats(added);
      _removeChats(removed);
      controller.chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(title: LocaleKeys.HomePage_navbarItems_chats.tr, actions: [
        if (chats.hasValue)
          IconButton(
            splashRadius: 18,
            onPressed: () {
              controller.showDeleteAllChatsBottomSheet(context);
            },
            icon: Assets.svg.verticalMenuIcon.svg(),
          )
        else
          const SizedBox.shrink(),
      ]),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConnectionStatusWidget(),
          Expanded(
            child: chats.when(
              data: (data) {
                if (data.isEmpty) {
                  return const EmptyChatsWidget();
                } else {
                  return SlidableAutoCloseBehavior(
                      child: AnimatedList(
                    key: controller.animatedListKey,
                    initialItemCount: data.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index, animation) {
                      final chat = data[index];
                      return SlideTransition(
                        position: _slideAnimation(animation),
                        child: ChatWidget(
                          chatId: chat.id,
                          name: chat.name,
                          lastMessage: chat.lastMessage,
                          timestamp: chat.timestamp,
                          participants: chat.participants,
                          notificationCount: chat.notificationCount,
                          isGroupChat: chat.isGroupChat,
                        ),
                      );
                    },
                  ));
                }
              },
              error: (error, stackTrace) => Center(child: Text(error.toString())),
              loading: () {
                return const Center(child: Text('Loading...'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Animation<Offset> _slideAnimation(Animation<double> animation) {
    return animation.drive(
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
          .chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  Widget _buildRemovedItem(ChatViewModel chat, Animation<double> animation) {
    return SlideTransition(
      position: _slideAnimation(animation),
      child: ChatWidget(
        chatId: chat.id,
        name: chat.name,
        lastMessage: chat.lastMessage,
        timestamp: chat.timestamp,
        participants: chat.participants,
        notificationCount: chat.notificationCount,
        isGroupChat: chat.isGroupChat,
      ),
    );
  }
}

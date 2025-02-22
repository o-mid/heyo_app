// ignore_for_file: require_trailing_commas

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_history_model.dart';
import 'package:heyo/modules/features/chats/presentation/widgets/delete_all_chats_bottom_sheet.dart';
import 'package:heyo/modules/features/chats/presentation/widgets/delete_chat_dialog.dart';

final chatsNotifierProvider =
    AsyncNotifierProvider<ChatHistoryController, List<ChatHistoryModel>>(
  () => ChatHistoryController(
    chatHistoryRepo: inject.get<ChatHistoryRepo>(),
    messagesRepo: inject.get<MessagesAbstractRepo>(),
  ),
);

class ChatHistoryController extends AsyncNotifier<List<ChatHistoryModel>> {
  ChatHistoryController({
    required this.chatHistoryRepo,
    required this.messagesRepo,
  });
  final ChatHistoryRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;

  @override
  FutureOr<List<ChatHistoryModel>> build() async {
    unawaited(listenToChatsUpdates());

    return _fetchInitialChats();
  }

  Future<List<ChatHistoryModel>> _fetchInitialChats() async {
    final chats = await chatHistoryRepo.getAllChats();

    return chats.map((chat) => chat).toList();
  }

  Future<void> listenToChatsUpdates() async {
    final chatsStream = await chatHistoryRepo.getChatsStream();
    final chats = state.value ?? [];
    chatsStream.listen((newChats) {
      final updatedChatsMap = <String, ChatHistoryModel>{};

      for (final chatModel in newChats) {
        updatedChatsMap[chatModel.id] = chatModel;
      }

      // Check for removed chats
      chats.removeWhere(
          (existingChat) => !updatedChatsMap.containsKey(existingChat.id));

      // Update existing chats or add new chats
      for (var chatId in updatedChatsMap.keys) {
        var existingChatIndex = chats.indexWhere((chat) => chat.id == chatId);
        if (existingChatIndex != -1) {
          chats[existingChatIndex] = updatedChatsMap[chatId]!;
        } else {
          chats.add(updatedChatsMap[chatId]!);
        }
      }

      // Sort chats by timestamp, newest first
      chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = AsyncData(chats);
    });
  }

  Future<void> deleteChat(String chatId) async {
    await chatHistoryRepo.deleteChat(chatId);
    await messagesRepo.deleteAllMessages(chatId);
  }

  void showDeleteAllChatsBottomSheet(BuildContext context) {
    final chats = state.value ?? [];
    openDeleteAllChatsBottomSheet(
        onDelete: () async {
          for (final element in chats) {
            await messagesRepo.deleteAllMessages(element.id);
          }
          await chatHistoryRepo.deleteAllChats();

          chats.clear();
        },
        context: context);
    state = AsyncData(chats);
  }

  Future<bool> showDeleteChatDialog(
    BuildContext context,
    String chatId,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return DeleteChatDialog(
              deleteChat: () async {
                await deleteChat(chatId);
                Navigator.of(context).pop(true);
              },
            );
          },
        ) ??
        false;
  }
}

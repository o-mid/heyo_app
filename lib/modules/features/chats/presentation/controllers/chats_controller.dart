import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_model.dart';

import 'package:heyo/modules/features/chats/presentation/widgets/delete_all_chats_bottom_sheet.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/chats/presentation/widgets/chat_widget.dart';

import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';

import '../widgets/delete_chat_dialog.dart';
import '../../../../../core/di/injector_provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

final chatsNotifierProvider = AsyncNotifierProvider<ChatsController, List<ChatModel>>(
  () => ChatsController(
    chatHistoryRepo: inject.get<ChatHistoryRepo>(),
    messagesRepo: inject.get<MessagesAbstractRepo>(),
    contactRepository: inject.get<LocalContactRepo>(),
  ),
);

class ChatsController extends AsyncNotifier<List<ChatModel>> {
  ChatsController({
    required this.chatHistoryRepo,
    required this.messagesRepo,
    required this.contactRepository,
  });
  final ChatHistoryRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;
  final LocalContactRepo contactRepository;

  List<ChatModel> chats = [];

  @override
  FutureOr<List<ChatModel>> build() async {
    unawaited(_fetchInitialChats());
    unawaited(listenToChatsUpdates());

    return chats;
  }

  Future<void> _fetchInitialChats() async {
    final chats = await chatHistoryRepo.getAllChats();

    state = AsyncData(chats.map((chat) => chat).toList());
  }

  Future<void> listenToChatsUpdates() async {
    final chatsStream = await chatHistoryRepo.getChatsStream();
    chatsStream.listen((newChats) {
      List<ChatModel> updatedChats = [];
      Map<String, ChatModel> updatedChatsMap = {};

      for (final chatModel in newChats) {
        updatedChatsMap[chatModel.id] = chatModel;
      }

      // Check for removed chats
      chats.removeWhere((existingChat) => !updatedChatsMap.containsKey(existingChat.id));

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

    chats.removeWhere((chat) => chat.id == chatId);
  }

  void showDeleteAllChatsBottomSheet(BuildContext context) {
    openDeleteAllChatsBottomSheet(
        onDelete: () async {
          for (final element in chats) {
            await messagesRepo.deleteAllMessages(element.id);
          }
          await chatHistoryRepo.deleteAllChats();

          chats.clear();
        },
        context: context);
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

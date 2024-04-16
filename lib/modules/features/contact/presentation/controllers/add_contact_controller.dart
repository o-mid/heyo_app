import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

final addContactNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AddContactsController, ContactModel?>(
  () => AddContactsController(
    contactRepo: inject.get<ContactRepo>(),
    chatHistoryRepo: inject.get<ChatHistoryRepo>(),
    messagesRepo: inject.get<MessagesAbstractRepo>(),
  ),
);

class AddContactsController extends AutoDisposeAsyncNotifier<ContactModel?> {
  AddContactsController({
    required this.contactRepo,
    required this.chatHistoryRepo,
    required this.messagesRepo,
  });
  final ContactRepo contactRepo;
  final ChatHistoryRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;

  late AddContactsViewArgumentsModel args;
  TextEditingController textController = TextEditingController();
  String coreId = '';

  @override
  FutureOr<ContactModel?> build() async {
    args = Get.arguments as AddContactsViewArgumentsModel;
    final contact = await contactRepo.getContactById(args.coreId);
    textController.text = contact != null ? contact.name : '';
    coreId = args.coreId;
    return contact;
  }

  Future<void> updateContact() async {
    final name = textController.text;
    if (name.isEmpty) {
      SnackBarWidget.error(message: 'Name should not be empty');
      return;
    }

    ContactModel newContact;
    if (state.value == null) {
      newContact = ContactModel(coreId: args.coreId, name: name);
      await contactRepo.addContact(newContact);
    } else {
      newContact = state.value!.copyWith(name: name);
      await contactRepo.updateUserContact(newContact);
    }
    // TODO(AliAzim): This should be removed after refactoring chat feature.
    await _updateChatHistory(newContact);
    Get.back(result: newContact.name);
  }

  Future<void> _updateChatHistory(ContactModel contact) async {
    final chatHistoryList = await chatHistoryRepo.getChatsFromUserId(contact.coreId);

    for (final chat in chatHistoryList) {
      final updatedParticipants = chat.participants
          .map(
            (participant) => participant.coreId == contact.coreId
                ? participant.copyWith(name: contact.name)
                : participant,
          )
          .toList();
      await chatHistoryRepo.updateChat(
        chat.copyWith(
          name: chat.isGroupChat ? chat.name : contact.name,
          participants: updatedParticipants,
        ),
      );
      await messagesRepo.updateMessagesSenderName(
        chatId: chat.id,
        coreId: contact.coreId,
        newSenderName: contact.name,
      );
    }
  }
}

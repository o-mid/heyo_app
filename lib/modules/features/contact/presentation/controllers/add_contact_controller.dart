import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

final addContactNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AddContactsController, ContactModel?>(
  () => AddContactsController(
    contactRepo: inject.get<ContactRepo>(),
    chatHistoryRepo: inject.get<ChatHistoryLocalAbstractRepo>(),
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
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
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
    // TODO(AliAzim): make sure this update is requires.
    await updateUserChatMode(newContact);
  }

  //Future<void> _initUserContact() async {
  //  // check if user is already in contact
  //  var createdContact = await contactRepo.getContactById(args.coreId);

  //  if (createdContact == null) {
  //    createdContact = await _cloneContactModel();
  //    await contactRepo.addContact(createdContact);
  //  } else {
  //    nickname.value = createdContact.name;
  //    myNicknameController.text = createdContact.name;
  //  }
  //}

  Future<void> updateUserChatMode(ContactModel contact) async {
    // check if user is already in contact
    final user = await contactRepo.getContactById(contact.coreId);

    if (user == null) {
      await contactRepo.addContact(contact);
    } else {
      await contactRepo.updateUserContact(contact);
    }
    await _updateChatHistory(contact);
    //await _updateCallHistory(userModel: userModel);

    Get.back(result: contact.name);
  }

  Future<void> _updateChatHistory(ContactModel contact) async {
    final chatHistoryList =
        await chatHistoryRepo.getChatsFromUserId(contact.coreId);

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

      await _updateMessagesRepo(
        chatId: chat.id,
        coreId: contact.coreId,
        newSenderName: contact.name,
      );
    }
  }

  //Future<void> _updateCallHistory({required UserModel userModel}) async {
  //  final callHistoryList =
  //      await callHistoryRepo.getCallsFromUserId(userModel.coreId);

  //  //* For loop for all stored call history
  //  for (final call in callHistoryList) {
  //    debugPrint('_updateCallHistory: ${call.callId}');

  //    final index = call.participants.indexWhere(
  //      (participant) => participant.coreId == userModel.coreId,
  //    );

  //    //* Check if the item was found
  //    if (index != -1) {
  //      //final newParticipants = call.participants.fi

  //      final updatedParticipant = call.participants[index];

  //      // Create a copy of the list
  //      final newParticipantList =
  //          List<CallHistoryParticipantModel>.from(call.participants);

  //      // Replace the old item with the new one
  //      newParticipantList[index] = updatedParticipant;

  //      // Create a new instance of the call with the updated list
  //      final updatedCall = call.copyWith(participants: newParticipantList);

  //      await callHistoryRepo.updateCall(updatedCall);
  //    }
  //  }
  //}

  Future<void> _updateMessagesRepo({
    required String chatId,
    required String coreId,
    required String newSenderName,
  }) async {
    await messagesRepo.updateMessagesSenderName(
      chatId: chatId,
      coreId: coreId,
      newSenderName: newSenderName,
    );
  }
}

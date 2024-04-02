import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class AddContactsController extends GetxController {
  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
    required this.callHistoryRepo,
    required this.messagesRepo,
  });

  late AddContactsViewArgumentsModel args;
  static String DefaultAvatarPath =
      'https://avatars.githubusercontent.com/u/2345136?v=4';
  RxString nickname = ''.obs;
  RxBool isContact = false.obs;
  RxBool isVerified = false.obs;
  TextEditingController myNicknameController = TextEditingController();

  final LocalContactRepo contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final CallHistoryRepo callHistoryRepo;

  final MessagesAbstractRepo messagesRepo;

  @override
  Future<void> onInit() async {
    args = Get.arguments as AddContactsViewArgumentsModel;
    await checkContactAvailability();
    super.onInit();
  }

  @override
  void onReady() {
    _initUserContact();
    super.onReady();
  }

  Future<void> checkContactAvailability() async {
    //TODO(AliAzim): all users are already in contact (if we call them once)
    final userContact = await contactRepository.getContactById(args.coreId);
    if (userContact == null) {
      isContact.value = false;
    } else {
      isContact.value = true;
    }
  }

  void setNickname(String name) {
    nickname.value = name;
  }

  Future<ContactModel?> _getContactById(String id) async {
    return contactRepository.getContactById(id);
  }

  Future<ContactModel> _cloneContactModel() async {
    return ContactModel(
      coreId: args.coreId,
      name: args.coreId.shortenCoreId,
    );
  }

  Future<void> updateContact() async {
    var contact = await _getContactById(args.coreId);
    if (contact == null) {
      contact = await _cloneContactModel();
      await contactRepository.addContact(contact);
    } else {
      final newContact = contact.copyWith(
        name:
            nickname.value.isEmpty ? args.coreId.shortenCoreId : nickname.value,
      );
      await updateUserChatMode(newContact);
    }
  }

  Future<void> _initUserContact() async {
    // check if user is already in contact
    var createdContact = await _getContactById(args.coreId);

    if (createdContact == null) {
      createdContact = await _cloneContactModel();
      await contactRepository.addContact(createdContact);
    } else {
      isContact.value = true;
      nickname.value = createdContact.name;
      myNicknameController.text = createdContact.name;
    }
  }

  Future<void> updateUserChatMode(ContactModel contact) async {
    // check if user is already in contact
    final user = await _getContactById(contact.coreId);

    if (user == null) {
      await contactRepository.addContact(contact);
    } else {
      await contactRepository.updateUserContact(contact);
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

  Future<void> _updateCallHistory({required UserModel userModel}) async {
    final callHistoryList =
        await callHistoryRepo.getCallsFromUserId(userModel.coreId);

    //* For loop for all stored call history
    for (final call in callHistoryList) {
      debugPrint('_updateCallHistory: ${call.callId}');

      final index = call.participants.indexWhere(
        (participant) => participant.coreId == userModel.coreId,
      );

      //* Check if the item was found
      if (index != -1) {
        //final newParticipants = call.participants.fi

        final updatedParticipant = call.participants[index];

        // Create a copy of the list
        final newParticipantList =
            List<CallHistoryParticipantModel>.from(call.participants);

        // Replace the old item with the new one
        newParticipantList[index] = updatedParticipant;

        // Create a new instance of the call with the updated list
        final updatedCall = call.copyWith(participants: newParticipantList);

        await callHistoryRepo.updateCall(updatedCall);
      }
    }
  }

  Future<void> _updateMessagesRepo(
      {required String chatId,
      required String coreId,
      required String newSenderName}) async {
    await messagesRepo.updateMessagesSenderName(
        chatId: chatId, coreId: coreId, newSenderName: newSenderName);
  }
}

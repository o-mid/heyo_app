import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import '../../shared/data/models/messaging_participant_model.dart';

class AddContactsController extends GetxController {
  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
    required this.callHistoryRepo,
  });

  late AddContactsViewArgumentsModel args;
  static String DefaultAvatarPath = 'https://avatars.githubusercontent.com/u/2345136?v=4';
  RxString nickname = ''.obs;
  RxBool isContact = false.obs;
  RxBool isVerified = false.obs;
  TextEditingController myNicknameController = TextEditingController();

  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final CallHistoryAbstractRepo callHistoryRepo;

  @override
  void onInit() async {
    args = Get.arguments as AddContactsViewArgumentsModel;
    super.onInit();
  }

  @override
  void onReady() {
    _initUserContact();
    super.onReady();
  }

  void setNickname(String name) {
    nickname.value = name;
  }

  Future<UserModel?> _getContactWith(String id) async {
    return contactRepository.getContactById(id);
  }

  Future<UserModel> _cloneUserModel() async {
    return UserModel(
      coreId: args.coreId,
      name: args.coreId.shortenCoreId,
      isOnline: true,
      isContact: isContact.value,
      walletAddress: args.coreId,
    );
  }

  Future<void> updateContact() async {
    var user = await _getContactWith(args.coreId);
    if (user == null) {
      user = await _cloneUserModel();
      await contactRepository.addContact(user);
    } else {
      await updateUserChatMode(
          userModel: user.copyWith(
        nickname: nickname.value,
        name: nickname.value.isEmpty ? args.coreId.shortenCoreId : nickname.value,
        isContact: true,
      ));
    }
  }

  Future<void> _initUserContact() async {
    // check if user is already in contact
    var createdUser = await _getContactWith(args.coreId);

    if (createdUser == null) {
      createdUser = await _cloneUserModel();
      await contactRepository.addContact(createdUser);
    } else {
      isContact.value = createdUser.isContact;
      nickname.value = createdUser.nickname;
      myNicknameController.text = createdUser.nickname;
    }
  }

  Future<void> updateUserChatMode({required UserModel userModel}) async {
    // check if user is already in contact
    var user = await _getContactWith(userModel.coreId);

    if (user == null) {
      await contactRepository.addContact(userModel);
    } else {
      await contactRepository.deleteContactById(userModel.coreId);
      await contactRepository.addContact(userModel);
    }
    await _updateChatHistory(userModel: userModel);
    await _updateCallHistory(userModel: userModel);

    Get.offNamedUntil(Routes.MESSAGES, ModalRoute.withName(Routes.HOME),
        arguments: MessagesViewArgumentsModel(
          participants: [
            MessagingParticipantModel(
              coreId: userModel.coreId,
              chatId: userModel.coreId,
            ),
          ],
        ));
  }

  Future<void> _updateChatHistory({required UserModel userModel}) async {
    await chatHistoryRepo.getChat(userModel.coreId).then((chatModel) {
      if (chatModel != null) {
        chatHistoryRepo.updateChat(chatModel.copyWith(
          name: userModel.nickname,
        ));
      }
    });
  }

  Future<void> _updateCallHistory({required UserModel userModel}) async {
    final callHistoryList = await callHistoryRepo.getCallsFromUserId(userModel.coreId);

    //* For loop for all stored call history
    for (final call in callHistoryList) {
      debugPrint('_updateCallHistory: ${call.callId}');

      final index = call.participants.indexWhere(
        (participant) => participant.coreId == userModel.coreId,
      );

      //* Check if the item was found
      if (index != -1) {
        //final newParticipants = call.participants.fi

        final updatedParticipant = call.participants[index].copyWith(
          name: userModel.name,
        );

        // Create a copy of the list
        final newParticipantList = List<CallHistoryParticipantModel>.from(call.participants);

        // Replace the old item with the new one
        newParticipantList[index] = updatedParticipant;

        // Create a new instance of the call with the updated list
        final updatedCall = call.copyWith(participants: newParticipantList);

        await callHistoryRepo.updateCall(updatedCall);
      }
    }
  }
}

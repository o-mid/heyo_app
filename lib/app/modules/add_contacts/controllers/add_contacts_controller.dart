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
  late RxString nickname;
  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final CallHistoryAbstractRepo callHistoryRepo;

  Rx<UserModel> user = UserModel(
    coreId: (Get.arguments as AddContactsViewArgumentsModel).coreId,
    iconUrl: (Get.arguments as AddContactsViewArgumentsModel).iconUrl ??
        'https://avatars.githubusercontent.com/u/2345136?v=4',
    name: (Get.arguments as AddContactsViewArgumentsModel).coreId.shortenCoreId,
    walletAddress: (Get.arguments).coreId as String,
    isBlocked: false,
    isOnline: false,
    isContact: false,
    isVerified: false,
    nickname: '',
  ).obs;

  @override
  void onInit() async {
    args = Get.arguments as AddContactsViewArgumentsModel;

    nickname = ''.obs;
    await _getUserContact();
    super.onInit();
  }

  void setNickname(String name) {
    user.value = user.value.copyWith(nickname: name);
    nickname.value = name;
  }

  Future<void> addContact() async {
    // UserModel user = UserModel(
    //   coreId: args.user.walletAddress,
    //   nickname: nickname.value,
    //   iconUrl: args.user.iconUrl,
    //   name: nickname.value,
    //   isOnline: true,
    //   walletAddress: args.user.walletAddress,
    //   isContact: true,
    // );
    await updateUserChatMode(
        userModel: user.value.copyWith(
      nickname: nickname.value,
      name: nickname.value,
      isContact: true,
    ));
  }

  _getUserContact() async {
    // check if user is already in contact
    var createdUser = await contactRepository.getContactById(args.coreId);

    if (createdUser == null) {
      createdUser = UserModel(
        coreId: args.coreId,
        iconUrl: args.iconUrl ??
            'https://avatars.githubusercontent.com/u/2345136?v=4',
        name: args.coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: args.coreId,
      );
      // adds the new user to the repo and update the UserModel
      await contactRepository.addContact(createdUser);
      user.value = createdUser;
    } else {
      user.value = createdUser;
    }
    user.refresh();
  }

  Future<void> updateUserChatMode({required UserModel userModel}) async {
    final user = await contactRepository.getContactById(userModel.coreId);
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
          coreId: userModel.coreId,
          participants: [
            MessagingParticipantModel(
              coreId: userModel.coreId,
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

        final updatedParticipant = call.participants[index].copyWith(
          name: userModel.name,
        );

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
}

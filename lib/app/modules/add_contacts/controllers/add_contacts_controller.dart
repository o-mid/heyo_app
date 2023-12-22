import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

import '../../../routes/app_pages.dart';
import '../../calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/models/messaging_participant_model.dart';

class AddContactsController extends GetxController {

  late AddContactsViewArgumentsModel args;

  RxString nickname = ''.obs;
  RxBool isContact = false.obs;
  RxBool isVerified = false.obs;

  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final CallHistoryAbstractRepo callHistoryRepo;

  // Rx<UserModel> user = UserModel(
  //   coreId: (Get.arguments as AddContactsViewArgumentsModel).coreId,
  //   iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
  //   name: (Get.arguments as AddContactsViewArgumentsModel).coreId.shortenCoreId,
  //   walletAddress: (Get.arguments).coreId as String,
  //   isBlocked: false,
  //   isOnline: false,
  //   isContact: false,
  //   isVerified: false,
  //   nickname: "",
  // ).obs;

  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
    required this.callHistoryRepo,
  });

  @override
  void onInit() async {

    args = Get.arguments as AddContactsViewArgumentsModel;
    isContact.value = false;
    nickname.value = '';
    await _initUserContact();
    super.onInit();
  }

  void setNickname(String name) {
    nickname.value = name;
  }

  Future<UserModel?> _getContactWith(String id) async{
    return contactRepository.getContactById(id);
  }

  Future<void> updateContact() async {

    UserModel? user = await _getContactWith(args.coreId);
    if (user == null) {

      var createdUser = UserModel(
        coreId: args.coreId,
        iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
        name: args.coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: args.coreId,
      );
      await contactRepository.addContact(createdUser);
    } else {
      await updateUserChatMode(
          userModel: user.copyWith(
            nickname: nickname.value,
            name: args.coreId.shortenCoreId,
            isContact: true,
          ));
    }
  }

  _initUserContact() async {

    // check if user is already in contact
    UserModel? createdUser = await _getContactWith(args.coreId);

    if (createdUser == null) {

      createdUser = UserModel(
        coreId: args.coreId,
        iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
        name: args.coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: args.coreId,
      );
      // adds the new user to the repo and update the UserModel
      await contactRepository.addContact(createdUser);
    } else {

      isContact.value = createdUser.isContact;
      nickname.value = createdUser.nickname;
    }
  }

  Future<void> updateUserChatMode({required UserModel userModel}) async {
    UserModel? user = await contactRepository.getContactById(userModel.coreId);
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
          iconUrl: userModel.iconUrl,
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
    await callHistoryRepo.getCallsFromUserId(userModel.coreId).then((calls) async {
      print("_updateCallHistory: ${calls.length}");
      for (var call in calls) {
        print("_updateCallHistory: ${call.id} : ${call.user}");
        await callHistoryRepo.deleteOneCall(call.id);
        await callHistoryRepo.addCallToHistory(call.copyWith(user: userModel));
      }
    });
  }
}

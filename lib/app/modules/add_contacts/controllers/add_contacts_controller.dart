import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../../routes/app_pages.dart';
import '../../calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

class AddContactsController extends GetxController {
  late AddContactsViewArgumentsModel args;
  late RxString nickname;
  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final CallHistoryAbstractRepo callHistoryRepo;

  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
    required this.callHistoryRepo,
  });

  @override
  void onInit() {
    args = Get.arguments as AddContactsViewArgumentsModel;

    nickname = args.user.nickname.obs;

    super.onInit();
  }

  void setNickname(String name) {
    args.user.nickname = name;
    nickname.value = name;
  }

  Future<void> addContact() async {
    UserModel user = UserModel(
      coreId: args.user.walletAddress,
      nickname: nickname.value,
      iconUrl: args.user.iconUrl,
      name: nickname.value,
      walletAddress: args.user.walletAddress,
      isContact: true,
    );
    await updateUserChatMode(userModel: user);
  }

  Future<void> updateUserChatMode({required UserModel userModel}) async {
    await contactRepository.addContact(userModel);
    await _updateChatHistory(userModel: userModel);
    await _updateCallHistory(userModel: userModel);

    Get.offNamedUntil(Routes.MESSAGES, ModalRoute.withName(Routes.HOME),
        arguments: MessagesViewArgumentsModel(user: userModel));
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
      for (var call in calls) {
        await callHistoryRepo.updateCall(call.copyWith(
          user: call.user.copyWith(
            icon: userModel.iconUrl,
            name: userModel.name,
            nickname: userModel.nickname,
            isContact: userModel.isContact,
          ),
        ));
      }
    });
  }
}

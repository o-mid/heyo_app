import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

class AddContactsController extends GetxController {
  late AddContactsViewArgumentsModel args;
  late RxString nickname;
  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;

  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
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
    await chatHistoryRepo.getChat(userModel.coreId).then((chatModel) {
      if (chatModel != null) {
        chatHistoryRepo.updateChat(chatModel.copyWith(
          name: userModel.nickname,
        ));
      }
    });
    Get.offNamedUntil(Routes.MESSAGES, ModalRoute.withName(Routes.HOME),
        arguments: MessagesViewArgumentsModel(user: userModel));
  }
}

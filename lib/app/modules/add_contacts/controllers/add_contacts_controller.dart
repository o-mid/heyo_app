import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';

class AddContactsController extends GetxController {
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

  AddContactsController({
    required this.contactRepository,
    required this.chatHistoryRepo,
    required this.callHistoryRepo,
  });

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
    UserModel? createdUser =
        await contactRepository.getContactById(args.coreId);

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
    UserModel? user = await contactRepository.getContactById(userModel.coreId);
    if (user == null) {
      await contactRepository.addContact(userModel);
    } else {
      await contactRepository.deleteContactById(userModel.coreId);
      await contactRepository.addContact(userModel);
    }
    await _updateChatHistory(userModel: userModel);
    await _updateCallHistory(userModel: userModel);

    Get.offNamedUntil(
      Routes.MESSAGES,
      ModalRoute.withName(Routes.HOME),
      arguments: MessagesViewArgumentsModel(
        coreId: userModel.coreId,
        iconUrl: userModel.iconUrl,
      ),
    );
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
    await callHistoryRepo
        .getCallsFromUserId(userModel.coreId)
        .then((calls) async {
      debugPrint('_updateCallHistory: ${calls.length}');
      for (final call in calls) {
        debugPrint('_updateCallHistory: ${call.id} : ${call.participants}');
        await callHistoryRepo.deleteOneCall(call.id);
        await callHistoryRepo.addCallToHistory(
          call.copyWith(participants: [userModel]),
        );
      }
    });
  }
}

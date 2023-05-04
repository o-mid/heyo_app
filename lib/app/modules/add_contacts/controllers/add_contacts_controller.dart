import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../new_chat/data/models/user_model.dart';

class AddContactsController extends GetxController {
  late AddContactsViewArgumentsModel args;
  late RxString nickname;
  final ContactRepository contactRepository;

  AddContactsController({required this.contactRepository});

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

  void addContact() {
    contactRepository.addContact(UserModel(
        coreId: args.user.walletAddress,
        nickname: nickname.value,
        iconUrl: args.user.iconUrl,
        name: '',
        walletAddress: args.user.walletAddress,
        isContact: true,
        chatModel: args.user.chatModel));
  }
}

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class AddContactsController extends GetxController {
  //TODO: Implement AddContactsController
  late AddContactsViewArgumentsModel args;
  late RxString nickname;
  final count = 0.obs;
  ContactRepository contactRepository = Get.find<ContactRepository>();

  @override
  void onInit() {
    args = Get.arguments as AddContactsViewArgumentsModel;

    nickname = args.user.nickname.obs;

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  void setNickname(String name) {
    args.user.nickname = name;
    nickname.value = name;
  }

  void addContact() {
    contactRepository.addContact(UserContact(
        coreId: args.user.walletAddress,
        nickName: nickname.value,
        icon: args.user.icon));
  }
}

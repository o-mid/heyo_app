import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';

class AddContactsController extends GetxController {
  //TODO: Implement AddContactsController
  late AddContactsViewArgumentsModel args;
  late RxString nickname;
  final count = 0.obs;

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
}

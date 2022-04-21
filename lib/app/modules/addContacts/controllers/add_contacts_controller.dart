import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/addContactsViewArgumentsModel.dart';

class AddContactsController extends GetxController {
  //TODO: Implement AddContactsController
  late AddContactsViewArgumentsModel args;
  final count = 0.obs;
  @override
  void onInit() {
    args = Get.arguments as AddContactsViewArgumentsModel;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

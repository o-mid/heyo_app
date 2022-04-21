import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/addContactsViewArgumentsModel.dart';

class AddContactsController extends GetxController {
  //TODO: Implement AddContactsController
  late AddContactsViewArgumentsModel args;
  TextEditingController nicknameController = TextEditingController();
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

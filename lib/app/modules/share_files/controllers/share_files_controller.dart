import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareFilesController extends GetxController {
  late TextEditingController inputController;

  final count = 0.obs;
  @override
  void onInit() {
    inputController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}

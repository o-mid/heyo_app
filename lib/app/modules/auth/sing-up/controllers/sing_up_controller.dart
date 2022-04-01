import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingUpController extends GetxController {
  //TODO: Implement SingUpController
  final pagecontroller = PageController();

  final count = 0.obs;
  @override
  void onInit() {
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

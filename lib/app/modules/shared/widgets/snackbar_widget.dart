import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class SnackBarWidget {
  static SnackbarController info({required String message, String? title}) {
    return Get.snackbar(
      title ?? 'Info',
      message,
      backgroundColor: COLORS.kMapBlue,
      colorText: COLORS.kWhiteColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static SnackbarController error({required String message, String? title}) {
    return Get.snackbar(
      title ?? 'Error',
      message,
      backgroundColor: COLORS.kStatesErrorColor,
      colorText: COLORS.kWhiteColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static SnackbarController success({required String message, String? title}) {
    return Get.snackbar(
      title ?? 'Success',
      message,
      backgroundColor: COLORS.kStatesSuccessColor,
      colorText: COLORS.kWhiteColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static SnackbarController custom({
    required String message,
    required String title,
    Widget? icon,
    Color? backgroundColor,
    Color? colorText,
  }) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      icon: icon,
    );
  }
}

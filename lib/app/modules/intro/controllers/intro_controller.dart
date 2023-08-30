import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/intro/widgets/loading_dialog.dart';
import 'package:heyo/app/modules/intro/widgets/verification_bottom_sheet.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IntroController extends GetxController {
  @override
  void onClose() {}

  corePassVerificationAction() async {
    //close the corePass bottom sheet
    Get.back();
    //TODO: checking verification
    Timer(
      const Duration(seconds: 2),
      () {
        //close the loading modal
        Get.back();
        Get.toNamed(Routes.VERIFIED_USER);
      },
    );
    openLoadingDialog();
  }

  openCorePassVerificationBottomSheet() async {
    await Get.bottomSheet(
      VerificationBottomSheet(
        onTap: () => corePassVerificationAction(),
      ),
      isScrollControlled: true,
      backgroundColor: COLORS.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  openLoadingDialog() async {
    await Get.defaultDialog(
      onWillPop: () async => false,
      radius: 8,
      title: "",
      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      content: const LoadingDialog(),
    );
  }
}

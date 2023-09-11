import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heyo/app/modules/intro/usecase/verification_with_corepass_use_case.dart';
import 'package:heyo/app/modules/intro/widgets/loading_dialog.dart';
import 'package:heyo/app/modules/intro/widgets/verification_bottom_sheet.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IntroController extends GetxController with WidgetsBindingObserver {
  final VerificationWithCorePassUseCase verificationWithCorePassUseCase;

  IntroController({required this.verificationWithCorePassUseCase});

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      debugPrint('app is resumed');
      // Add 2 seconds timer so if the user is in resume and
      // no incoming link arrived, we dispose the stream
      Timer(
        const Duration(seconds: 2),
        () {
          //close the loading modal
          if (Get.isDialogOpen == true) {
            Get.back();
            verificationWithCorePassUseCase.getUriFromDeepLink();
            debugPrint("Verification not complete");
          }
        },
      );
    }
  }

  corePassVerificationAction() async {
    //close the corePass bottom sheet
    Get.back();
    openLoadingDialog();
    //TODO: checking verification

    // Launch corePass application
    //await verificationWithCorePassUseCase.executeLaunch();

    // Comment launching and just push to verified user
    Timer(
      const Duration(seconds: 2),
      () async {
        Get.back();
        //TODO: Set isLogin to true, temporary
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLogin", true);
        Get.offAllNamed(Routes.VERIFIED_USER);
      },
    );
  }

  openCorePassVerificationBottomSheet() async {
    await Get.bottomSheet(
      VerificationBottomSheet(onTap: () => corePassVerificationAction()),
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

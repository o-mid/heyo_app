import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_repo.dart';
import 'package:heyo/app/modules/intro/usecase/verification_with_corepass_use_case.dart';
import 'package:heyo/app/modules/intro/widgets/verification_loading_dialog.dart';
import 'package:heyo/app/modules/intro/widgets/verification_bottom_sheet.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:tuple/tuple.dart';

class IntroController extends GetxController with WidgetsBindingObserver {
  final IntroRepo introRepo;
  final P2PState p2pState;

  IntroController({required this.introRepo, required this.p2pState});

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
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      debugPrint('app is resumed');
      // Add 2 seconds timer so if the user is in resume and
      // no incoming link arrived, we dispose the stream
      Timer(
        const Duration(seconds: 2),
        () async {
          //close the loading modal
          if (Get.isDialogOpen == true) {
            Get.back();
            debugPrint("Verification not complete");
          }
        },
      );
    }
  }

  Future<void> _corePassVerificationAction() async {
    //close the corePass bottom sheet
    Get.back();
    _openLoadingDialog();

    if (await waitUntilCoreIdIsReady()) {
      await _launchCorePassVerificationProcess();
    }
  }

  Future<void> openCorePassVerificationBottomSheet() async {
    await Get.bottomSheet(
      VerificationBottomSheet(onTap: _corePassVerificationAction),
      isScrollControlled: true,
      backgroundColor: COLORS.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void _openLoadingDialog() {
    Get.defaultDialog(
      onWillPop: () async => false,
      radius: 8,
      title: "",
      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      content: const VerificationLoading(),
    );
  }

  Future<void> _launchCorePassVerificationProcess() async {
    /// wait for getting local core id from p2pCom
    // Launch corePass application
    final corePassData = await introRepo.retrieveCoreIdFromCorePass();
    // check if it was successful
    if (corePassData.item1) {
      await applyAndValidateDelegatedAuth(corePassData);
    } else {
      // close dialog
      Get.back();
      introRepo.launchStore();
    }
  }

  Future<bool> waitUntilCoreIdIsReady() async {
    final jobCompleter = Completer<String>();
    if (p2pState.peerId.value.isNotEmpty) return true;
    final listener = p2pState.peerId.listen((value) {
      if (value.isNotEmpty) {
        jobCompleter.complete(value);
      }
    });
    await jobCompleter.future;

    /// cancels subscription
    await listener.cancel();
    return true;
  }

  Future<void> applyAndValidateDelegatedAuth(
    Tuple3<bool, String, String> corePassData,
  ) async {
    final isSuccessfulAndValid = await introRepo.applyDelegatedCredentials(
      corePassData.item2,
      corePassData.item3,
    );
    if (isSuccessfulAndValid) {
      await Get.offAllNamed(Routes.VERIFIED_USER);
    } else {
      Get.snackbar('Error : ', 'Signature is invalid');
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_repo.dart';
import 'package:heyo/app/modules/intro/widgets/verification_loading_dialog.dart';
import 'package:heyo/app/modules/intro/widgets/verification_bottom_sheet.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/data/models/account_types.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/account/app_account_repository.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:tuple/tuple.dart';

class IntroController extends GetxController with WidgetsBindingObserver {
  final IntroRepo introRepo;
  final AccountRepository appAccountRepository;
  final P2PState p2pState;

  IntroController(
      {required this.appAccountRepository,
      required this.introRepo,
      required this.p2pState});

  @override
  Future<void> onInit() async {
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
    }
  }

  Future<void> _corePassVerificationAction() async {
    //close the corePass bottom sheet
    Get.back();
    _openLoadingDialog();
    await _launchCorePassVerificationProcess();
  }

  Future<void> openCorePassVerificationBottomSheet() async {
    await Get.bottomSheet(
      VerificationBottomSheet(onTap: _corePassVerificationAction),
      isScrollControlled: true,
      backgroundColor: COLORS.kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
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
    /// lets first create account and core id
    await introRepo.initConnectionContractor();

    // Launch corePass application
    final corePassData = await introRepo.retrieveCoreIdFromCorePass();
    // check if it was successful
    if (corePassData.item1) {
      await saveDelegatedAuth(corePassData);
    } else {
      // close dialog
      Get.back();
      introRepo.launchStore();
    }
  }

  Future<void> saveDelegatedAuth(
    Tuple3<bool, String, String> corePassData,
  ) async {
    final isSuccessfulAndValid = await introRepo.applyDelegatedCredentials(
      corePassData.item2,
      corePassData.item3,
    );
    if (isSuccessfulAndValid) {
      await Get.offAllNamed(Routes.VERIFIED_USER);
    } else {
      SnackBarWidget.error(
        message: 'Signature is invalid',
      );
    }
  }
}

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/stream.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountController extends GetxController {
  final AccountRepository _accountInfoRepo;
  final coreId = "".obs;
  final appVersion = "".obs;

  AccountController({required AccountRepository accountInfoRepo})
      : _accountInfoRepo = accountInfoRepo;

  @override
  void onInit() async {
    super.onInit();
    coreId.value = (await _accountInfoRepo.getUserAddress()) ?? "";
  }

  void logout() {
    _accountInfoRepo.logout().then((value) async {
      final loggedOut = await _accountInfoRepo
          .onAccountStateChanged()
          .waitForResult(condition: (bool value) => value == true);
      if (loggedOut) {
        await Get.offAllNamed(Routes.INTRO);
      }
    });
  }

  Future<void> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

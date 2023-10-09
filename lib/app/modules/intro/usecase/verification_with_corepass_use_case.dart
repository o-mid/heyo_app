import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';

class VerificationWithCorePassUseCase {
  final AccountInfo accountInfo;

  VerificationWithCorePassUseCase({required this.accountInfo});

  Future<void> executeLaunch() async {
    String? heyoId = await accountInfo.getCoreId();
    while (heyoId == null) {
      Get.rawSnackbar( messageText:  Text(
        "Sending Files feature is in development phase",
        textAlign: TextAlign.center,
          style: TEXTSTYLES.kBodySmall
      ));
      await Future.delayed(const Duration(seconds: 5));
      heyoId = await accountInfo.getCoreId();
    }
    // App scheme for corePass
    //String uri = 'corepass://authentication?heyoId=$heyoId';
    final uri = 'corepass:sign/?data=${heyoId}&conn=heyo://auth&dl=${getCurrentTimeInSeconds()+300}&type=app-link';
    print("deeep Link ${uri}");
    void launchStore() {
      String corePassAppStoreUri = '';
      String corePassPlayStoreUri = '';
      if (Platform.isIOS) {
        launchUrlString(corePassAppStoreUri);
      } else if (Platform.isAndroid) {
        launchUrlString(corePassPlayStoreUri);
      }
    }

    try {
      await launchUrlString(uri);
      debugPrint('The app is installed on the device.');
    } catch (e) {
      debugPrint(e.toString());
      //
      // Close the loading dialog
      Get.back();
      //
      //TODO: Open google play or app store
      launchStore();
      return;
    }
  }

  int getCurrentTimeInSeconds() {
    final ms = DateTime.now().millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
  void _checkUri(Uri deepLink) async {
    debugPrint("Uri is ${deepLink}");

    final result=deepLink.queryParameters;

    final signature=result['signature'];
    final coreId= result['coreID'];
    debugPrint("signature is $signature");
    debugPrint("coreId is $coreId");

    debugPrint("QUERY is $result");
    // Add 2 seconds timer for showing the loading

    debugPrint("Verification complete");
    //TODO: Set isLogin to true, temporary
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", true);
    // Navigate to verified user page
    Get.offAllNamed(Routes.VERIFIED_USER);
  }
  Future<void> getUriFromDeepLink() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        // Handle the initial deep uri
        _checkUri(initialUri);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

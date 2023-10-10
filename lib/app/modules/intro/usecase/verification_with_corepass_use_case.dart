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
    String? heyoId = await accountInfo.getLocalCoreId();
    while (heyoId == null) {
      Get.rawSnackbar( messageText:  Text(
        "Generating id...",
        textAlign: TextAlign.center,
          style: TEXTSTYLES.kBodySmall
      ));
      await Future.delayed(const Duration(seconds: 5));
      heyoId = await accountInfo.getLocalCoreId();
    }
    // App scheme for corePass
    final uri = 'corepass:sign/?data=${heyoId}&conn=heyo://auth&dl=${_getCurrentTimeInSeconds()+300}&type=app-link';
    print("deeep Link ${uri}");


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
      _launchStore();
      return;
    }
  }

  int _getCurrentTimeInSeconds() {
    final ms = DateTime.now().millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
  void _launchStore() {
    String corePassAppStoreUri = '';
    String corePassPlayStoreUri = '';
    if (Platform.isIOS) {
      launchUrlString(corePassAppStoreUri);
    } else if (Platform.isAndroid) {
      launchUrlString(corePassPlayStoreUri);
    }
  }
  void _checkUri(Uri deepLink) async {
    debugPrint("Uri is ${deepLink}");

    final result=deepLink.queryParameters;

    final signature=result['signature'];
    final coreId= result['coreID'];
    if(signature!=null &&coreId!=null){
     await accountInfo.setSignature(signature);
      await accountInfo.setCoreId(coreId);

      // Navigate to verified user page
      await Get.offAllNamed(Routes.VERIFIED_USER);
    }else {
      //todo show error
    }

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

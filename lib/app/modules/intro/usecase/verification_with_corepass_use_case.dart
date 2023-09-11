import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // App scheme for corePass
    String uri = 'dongi://authentication?heyoId=$heyoId';
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

  Future<void> getUriFromDeepLink() async {
    try {
      void checkUri(Uri deepLink) async {
        String? query = deepLink.queryParameters['key'];
        debugPrint("QUERY is $query");
        // Add 2 seconds timer for showing the loading

        debugPrint("Verification complete");
        //TODO: Set isLogin to true, temporary
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLogin", true);
        // Navigate to verified user page
        Get.offAllNamed(Routes.VERIFIED_USER);
      }

      final initialUri = await getInitialUri();
      if (initialUri != null) {
        // Handle the initial deep uri
        checkUri(initialUri);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

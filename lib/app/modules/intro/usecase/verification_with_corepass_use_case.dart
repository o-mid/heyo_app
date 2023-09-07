import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';

class VerificationWithCorePassUseCase {
  final AccountInfo accountInfo;

  VerificationWithCorePassUseCase({required this.accountInfo});

  StreamSubscription? subscription;

  Future<void> executeLaunch() async {
    String? heyoId = await accountInfo.getCoreId();
    // App scheme for corePass
    String uri = 'corepass://authentication?heyoId=$heyoId';

    try {
      // The canLaunchUrlString it's not working for android
      // we need to launch it & see it got error or not
      if (Platform.isAndroid) {
        await launchUrlString(uri);
        //
        // Now on the app will listen to incoming link
        await handleDeepLink();
        debugPrint('The app is installed on the device.');
      } else if (Platform.isIOS) {
        if (await canLaunchUrlString(uri)) {
          await launchUrlString(uri);
          //
          // Now on the app will listen to incoming link
          await handleDeepLink();
          debugPrint('The app is installed on the device.');
        } else {
          throw 'The app is not installed on the device.';
        }
      } else {
        debugPrint("The platform is not supported");
      }
    } catch (e) {
      debugPrint('Error checking app installation: $e');
      debugPrint('The app is not installed on the device.');
      //TODO: Open google play or app store
      _launchStore();
      return;
    }
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

  Future<void> handleDeepLink() async {
    try {
      void handleDeepLink(Uri deepLink) {
        String? query = deepLink.queryParameters['key'];
        debugPrint("QUERY is $query");
        // Add 2 seconds timer for showing the loading
        Timer(
          const Duration(seconds: 2),
          () async {
            // dispose the streamSubscription
            dispose();
            debugPrint("Verification complete");
            //TODO: Set isLogin to true, temporary
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isLogin", true);
            // Navigate to verified user page
            Get.offAllNamed(Routes.VERIFIED_USER);
          },
        );
      }

      final initialUri = await getInitialUri();
      if (initialUri != null) {
        // Handle the initial deep uri
        handleDeepLink(initialUri);
      }

      subscription = uriLinkStream.listen(
        (Uri? uri) {
          debugPrint('got uri: $uri');
          if (uri != null) {
            handleDeepLink(uri);
          }
        },
        onError: (Object err) {
          debugPrint('got err: $err');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  dispose() {
    if (subscription == null) return;
    subscription!.cancel();
  }
}

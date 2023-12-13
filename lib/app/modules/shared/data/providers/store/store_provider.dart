import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heyo/app/modules/shared/data/providers/store/store_abstract_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StoreProvider extends StoreAbstractProvider {
  @override
  bool launchStoreForUri(String uri) {
    try {
      if (Platform.isIOS) {
        launchUrlString(uri);
      } else if (Platform.isAndroid) {
        launchUrlString(uri);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_abstract_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepository extends SplashAbstractRepository {
  SplashRepository();

  @override
  Future<void> removeStorageOnFirstRun() async {
    // checks if Platform isIOS and if it's the first run of the app clears the Keychain
    if (Platform.isIOS) {
      // remove secure storage data on IOS manually,
      // because it's not cleaned after the app uninstall
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('first_run') ?? true) {
        // sets a key-value pair of first run in IOS NSUserDefaults with shared_preferences
        await prefs.setBool('first_run', false);
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
      }
    }
  }
}

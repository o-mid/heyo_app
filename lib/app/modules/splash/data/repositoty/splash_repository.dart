import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_abstract_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepository extends SplashAbstractRepository {
  NotificationProvider notificationProvider;
  RegistryProvider registryProvider;

  SplashRepository({
    required this.notificationProvider,
    required this.registryProvider,
  });

  @override
  Future<bool> fetchAllRegistries() async {
    final result = await registryProvider.getAll();
    final registryModel = RegistryInfoModel.fromContractModel(result);
    await registryProvider.saveRegistry(registryModel);
    return true;
  }

  @override
  Future<void> checkFirstRunIos() async {
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

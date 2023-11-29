import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_abstract_repository.dart';

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
}

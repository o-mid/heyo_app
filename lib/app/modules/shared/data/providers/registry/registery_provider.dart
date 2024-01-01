import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/contracts/Registry.g.dart';

abstract class RegistryProvider {
  Future<GetAll> getAll();

  Future<void> saveRegistry(RegistryInfoModel registryInfoModel);

  Future<RegistryInfoModel?> getRegistryInfo();

  Future<String?> createFcmRegisterSignature({
    required String fcmToken,
    required String privateKey,
  });
}

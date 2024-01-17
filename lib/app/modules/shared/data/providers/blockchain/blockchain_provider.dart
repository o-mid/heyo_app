import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provider.dart';
import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';

abstract class BlockchainProvider {
  Future<void> init();

  Future<KYCVault?> getKYCVault();

  Future<Registry> getRegistryAbi();

  Future<KycVaultProvider?> getKYCVaultProvider();

  Future<void> saveRegistry(RegistryInfoModel registryInfoModel);

  Future<RegistryInfoModel?> getRegistryInfo();

  Future<String?> createFcmRegisterSignature(
      {required String fcmToken, required String privateKey});
}

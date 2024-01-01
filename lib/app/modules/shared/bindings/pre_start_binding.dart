import 'package:core_web3dart/credentials.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provilder_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/dio/dio_network_request.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/app_registry_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/constants/web3client_constant.dart';
import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';

class PreStartBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..put<NetworkRequest>(DioNetworkRequest(), permanent: true)
      ..put<LibP2PStorageProvider>(
        LibP2PStorageProvider(
          localProvider: GlobalBindings.secureStorageProvider,
        ),
      );

    int? networkId;
    networkId = await GlobalBindings.web3Client.getNetworkId();

    Get
      ..put(
        Registry(
          address: XCBAddress.fromHex(REGISTRY_ADDR),
          client: GlobalBindings.web3Client,

          /// Here we should pass network id which is variable that should
          /// be extracted from web3client
          chainId: networkId,
        ),
      )
      ..put<RegistryProvider>(
        AppRegistryProvider(
          storageProvider: GlobalBindings.secureStorageProvider,
          registry: Get.find(),
        ),
      )
      ..put<BlockchainProvider>(
        BlockchainProviderImpl(
          registryProvider: Get.find(),
          web3client: GlobalBindings.web3Client,
        ),
      );

    await fetchRegistry();
    await initDependentObjects(networkId);
  }

  Future<void> initDependentObjects(int networkId) async {
    final registry = await Get.find<RegistryProvider>().getRegistryInfo();
    if (registry == null) return;
    Get
      ..put(
        KYCVault(
          address: XCBAddress.fromHex(registry!.kycVaultAddress),
          client: GlobalBindings.web3Client,
          chainId: networkId,
        ),
      )
      ..put<KycVaultProvider>(KycVaultProviderImpl(Get.find()));
  }

  Future<void> fetchRegistry() async {
    final registryProvider = Get.find<RegistryProvider>();
    final result = await registryProvider.getAll();
    final registryModel = RegistryInfoModel.fromContractModel(result);
    await registryProvider.saveRegistry(registryModel);
  }
}

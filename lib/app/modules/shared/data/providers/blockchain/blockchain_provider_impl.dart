import 'dart:async';

import 'package:core_web3dart/credentials.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:retry/retry.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';

class BlockchainProviderImpl extends BlockchainProvider {

  BlockchainProviderImpl(
      {required this.registryProvider, required this.web3client});
  RegistryProvider registryProvider;
  Web3Client web3client;

  @override
  Future<KYCVault?> getKYCVault() async {
    final registry = await registryProvider.getRegistryInfo();
    if (registry == null) return null;
    return KYCVault(
        address: XCBAddress.fromHex(registry!.kycVaultAddress),
        client: web3client,
        chainId: await web3client.getNetworkId());
  }

  @override
  Future<Registry> getRegistryAbi() async {
    return Registry(
        address: XCBAddress.fromHex(REGISTRY_ADDR),
        client: web3client,
        chainId: await web3client.getNetworkId());
  }

  @override
  Future<void> init() async {
    final result = await retry(
      () => registryProvider.getAll(),
      retryIf: (e) => true,
      maxAttempts: double.maxFinite.toInt(),
      randomizationFactor: 0.01,
      maxDelay: 3.seconds,
    );
    final registryModel = RegistryInfoModel.fromContractModel(result);
    await registryProvider.saveRegistry(registryModel);
  }
}

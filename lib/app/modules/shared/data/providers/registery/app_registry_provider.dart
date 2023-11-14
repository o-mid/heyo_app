import 'dart:convert';

import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/app/modules/shared/data/models/get_all_contract_model.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/registery/registery_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/secure_storage_provider.dart';

String REGISTRY_MODEL = 'registry_model';

class AppRegistryProvider extends RegistryProvider {
  AppRegistryProvider({
    required this.blockChainProvider,
    required this.web3,
    required this.storageProvider,
  });

  final BlockchainProvider blockChainProvider;
  final Web3Client web3;
  final SecureStorageProvider storageProvider;

  Future<DeployedContract> get loadedContract async => await blockChainProvider
      .loadContract(REGISTERY_ADDR, registeryContractAsset, "Registery");

  @override
  Future<GetAllContractModel> getAll() async {
    final registeryContract = await loadedContract;
    final response = await blockChainProvider.queryContract(
      'getAll',
      [],
      registeryContract,
      web3,
    );
    return GetAllContractModel(response);
  }

  @override
  Future<void> saveRegistry(RegistryInfoModel registryInfoModel) async {
    await storageProvider.saveToStorage(
      REGISTRY_MODEL,
      jsonEncode(
        registryInfoModel.toJSON(),
      ),
    );
  }

  @override
  Future<RegistryInfoModel> getRegistry() async {
    final rawModel = await storageProvider.readFromStorage(REGISTRY_MODEL);
    return jsonDecode(rawModel!) as RegistryInfoModel;
  }
}

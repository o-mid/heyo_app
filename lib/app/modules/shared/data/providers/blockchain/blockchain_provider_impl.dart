import 'dart:async';
import 'dart:convert';

import 'package:core_web3dart/credentials.dart';
import 'package:core_web3dart/crypto.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provilder_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/local_storages_abstract.dart';
import 'package:retry/retry.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';

String REGISTRY_MODEL = 'registry_model';

class BlockchainProviderImpl extends BlockchainProvider {
  BlockchainProviderImpl(
      {required this.storageProvider, required this.web3client}) {
    init();
  }

  LocalStorageAbstractProvider storageProvider;
  Web3Client web3client;

  @override
  Future<KYCVault?> getKYCVault() async {
    final registry = await getRegistryInfo();
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
      () async => (await getRegistryAbi()).getAll(),
      retryIf: (e) => true,
      maxAttempts: double.maxFinite.toInt(),
      randomizationFactor: 0.01,
      maxDelay: 3.seconds,
    );
    final registryModel = RegistryInfoModel.fromContractModel(result);
    await saveRegistry(registryModel);
  }

  @override
  Future<KycVaultProvider?> getKYCVaultProvider() async {
    final kycVault = await getKYCVault();
    if (kycVault == null) return null;
    return KycVaultProviderImpl(kycVault);
  }

  @override
  Future<void> saveRegistry(RegistryInfoModel registryInfoModel) async {
    await storageProvider.deleteFromStorage(REGISTRY_MODEL);
    await storageProvider.saveToStorage(
      REGISTRY_MODEL,
      jsonEncode(
        registryInfoModel.toJSON(),
      ),
    );
  }

  @override
  Future<RegistryInfoModel?> getRegistryInfo() async {
    final rawModel = await storageProvider.readFromStorage(REGISTRY_MODEL);

    if (rawModel == null || rawModel.isEmpty) return null;

    return RegistryInfoModel.fromJSON(
      jsonDecode(rawModel!) as Map<String, dynamic>,
    );
  }

  @override
  Future<String?> createFcmRegisterSignature(
      {required String fcmToken, required String privateKey}) async {
    const eip712DomainName = 'EIP712Domain';
    final eip712DomainVal = <Map<String, dynamic>>[
      {'name': 'name', 'type': 'string'},
      {'name': 'version', 'type': 'string'},
      {'name': 'networkId', 'type': 'uint256'},
      {'name': 'verifyingContract', 'type': 'address'}
    ];

    final registryInfo = await getRegistryInfo();
    if (registryInfo == null) return null;

    final domain = {
      'name': 'NotificationServer',
      'version': '1',
      'networkId': 0,
      'verifyingContract': registryInfo.kycTransmitterAddress,
    };
    final notificationType = [
      {'name': 'fcmToken', 'type': 'string'}
    ];

    final fcmToSign = {
      'domain': domain,
      'primaryType': 'RegisterToken',
      'types': {
        eip712DomainName: eip712DomainVal,
        'RegisterToken': notificationType
      },
      'message': {
        'fcmToken': fcmToken,
      }
    };
    try {
      final eipMessage = EIP712().getMessageForSign(typedData: fcmToSign);
      final sigMsg =
          signWithPrivKey(hexToBytes(eipMessage), hexToBytes(privateKey));
      return bytesToHex(sigMsg, include0x: true);
    } catch (e, s) {
      throw Exception(e);
    }
  }
}

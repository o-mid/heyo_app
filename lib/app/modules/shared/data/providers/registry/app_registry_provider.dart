import 'dart:convert';

import 'package:core_web3dart/crypto.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/app/modules/shared/data/models/get_all_contract_model.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
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

  Future<DeployedContract> get loadedContract async => blockChainProvider
      .loadContract(REGISTERY_ADDR, registeryContractAsset, 'Registery');

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
    await storageProvider.deleteFromStorage(REGISTRY_MODEL);
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
    return RegistryInfoModel.fromJSON(
      jsonDecode(rawModel!) as Map<String, dynamic>,
    );
  }

  @override
  Future<String> createFcmRegisterSignature(
      {required String fcmToken, required String privateKey}) async {
    const eip712DomainName = 'EIP712Domain';
    final eip712DomainVal = <Map<String, dynamic>>[
      {'name': 'name', 'type': 'string'},
      {'name': 'version', 'type': 'string'},
      {'name': 'networkId', 'type': 'uint256'},
      {'name': 'verifyingContract', 'type': 'address'}
    ];

    final registryInfo = await getRegistry();

    print('KYC ADDRESS : ${registryInfo.kycTransmitterAddress}');

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

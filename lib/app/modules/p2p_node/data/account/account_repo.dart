import 'dart:convert';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

class AccountRepo implements AccountInfo {
  final LocalStorageAbstractProvider localProvider;
  final CryptographyKeyGenerator cryptographyKeyGenerator;

  AccountRepo({required this.localProvider, required this.cryptographyKeyGenerator});

  @override
  Future<String?> getP2PSecret() async {
    final p2pSecret = await localProvider.readFromStorage(P2P_KEY_IN_STORE);
    return p2pSecret;
  }

  @override
  Future<void> setP2PSecret(String p2pSecret) async {
    await localProvider.saveToStorage(P2P_KEY_IN_STORE, p2pSecret);
  }

  @override
  Future<void> createAccount() async {
    late String privateKey;
    late List<String> phrases;
    phrases = cryptographyKeyGenerator.generate_mnemonic();
    privateKey = await cryptographyKeyGenerator.generatePrivateKeysFromMneomonic(phrases, "198491");

    final address = await cryptographyKeyGenerator.generateAddress(privateKey);
    final pubKey = await cryptographyKeyGenerator.getPublicKeyFromPrivate(privateKey);
    final coreId = await cryptographyKeyGenerator.generateCoreIdFromPriv(privateKey);
    // we save the credentials in the key chain

    await saveCredentials(coreId, privateKey, null, phrases, address, pubKey);
  }

  @override
  Future<void> saveCredentials(String coreId, String privateKey, String? aesKey,
      List<String> mneomns, String address, String publicKey) async {
    final Map<String, dynamic> credentials = {
      CORE_ID_KEY_IN_STORE: coreId.toLowerCase(),
      PRIV_KEY_IN_STORE: privateKey,
      AES_KEY_IN_STORE: aesKey,
      MNEOMONIC_IN_STORE: mneomns.join(','),
      PUBLIC_KEY: publicKey,
      ADDRESS: address
    };
    await localProvider.saveToStorage(CRED_KEY_IN_STORE, jsonEncode(credentials));
  }

  @override
  Future<String?> getCoreId() async {
    final credentialInLocalStorage = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (credentialInLocalStorage == null) {
      return null;
    } else {
      final previousCredential = (jsonDecode(credentialInLocalStorage) as Map<String, dynamic>);
      return previousCredential[CORE_ID_KEY_IN_STORE];
    }
  }

  @override
  Future<String?> getPrivateKey() async {
    final prevs = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (prevs == null) {
      return null;
    } else {
      final previousCreds = ((jsonDecode(prevs) as Map<String, dynamic>));
      return previousCreds[PRIV_KEY_IN_STORE];
    }
  }
}

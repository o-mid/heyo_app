import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:heyo/app/modules/p2p_node/auth_keys_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

class AccountManager extends AccountInfo {
  final LocalStorageAbstractProvider localProvider;
  final CryptographyKeyGenerator cryptographyKeyGenerator;

  AccountManager(
      {required this.localProvider, required this.cryptographyKeyGenerator});

  @override
  Future<String?> getP2PSecret() async {
    final _p2pSecret = await localProvider.readFromStorage(P2P_KEY_IN_STORE);
    return _p2pSecret;
  }

  @override
  Future<void> setP2PSecret(String p2pSecret) async {
    await localProvider.saveToStorage(P2P_KEY_IN_STORE, p2pSecret);
  }

  @override
  Future<void> createAccount() async {
    late KeysModel privateKeys;
    late List<String> phrases;
    await Future.doWhile(() async {
      phrases = cryptographyKeyGenerator.generate_mnemonic();
      privateKeys = await cryptographyKeyGenerator
          .generatePrivateKeysFromMneomonic(phrases, "198491");
      if (privateKeys.goldiLockPrivateKey.startsWith("00")) {
        return true;
      } else {
        return false;
      }
    });

    final address = await cryptographyKeyGenerator
        .generateAddress(privateKeys.goldiLockPrivateKey);
    final pubKey = await cryptographyKeyGenerator
        .getPublicKeyFromPrivate(privateKeys.goldiLockPrivateKey);
    final coreId = await cryptographyKeyGenerator
        .generateCoreIdFromPriv(privateKeys.goldiLockPrivateKey);
    // we save the credentials in the key chain
    await saveCredentials(coreId, privateKeys.goldiLockPrivateKey,
        privateKeys.aesKey, phrases, address, pubKey);
  }

  @override
  Future<void> saveCredentials(String coreId, String privateKey, String aesKey,
      List<String> mneomns, String address, String publicKey) async {
    final Map<String, dynamic> _credentials = {
      CORE_ID_KEY_IN_STORE: coreId.toLowerCase(),
      PRIV_KEY_IN_STORE: privateKey,
      AES_KEY_IN_STORE: aesKey,
      MNEOMONIC_IN_STORE: mneomns.join(','),
      PUBLIC_KEY: publicKey,
      ADDRESS: address
    };
    await localProvider.saveToStorage(
        CRED_KEY_IN_STORE, jsonEncode(_credentials));
  }

  @override
  Future<String?> getCoreId() async {
    final _credentialInLocalStorage =
        await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (_credentialInLocalStorage == null) {
      return null;
    } else {
      final _previousCredential =
          (jsonDecode(_credentialInLocalStorage) as Map<String, dynamic>);
      return _previousCredential[CORE_ID_KEY_IN_STORE];
    }
  }

  @override
  Future<String?> getPrivateKey() async {
    final _prevs = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (_prevs == null) {
      return null;
    } else {
      final _previousCreds = ((jsonDecode(_prevs) as Map<String, dynamic>));
      return _previousCreds[PRIV_KEY_IN_STORE];
    }
  }
}

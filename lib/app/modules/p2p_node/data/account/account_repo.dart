import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';

String P2P_KEY_IN_STORE = "P2P_KEY_IN_STORE";
String CRED_KEY_IN_STORE = "CRED_KEY_IN_STORE";
String CORE_ID_KEY_IN_STORE = "coreId";
String PRIV_KEY_IN_STORE = "priv";
String AES_KEY_IN_STORE = "AES";
String MNEOMONIC_IN_STORE = "mneomonic";
String PUBLIC_KEY = "public_key";
String ADDRESS = "address";
String COREPASS_ID = "corePassId";
String COREPASS_SIGNATURE = "signature";

class AccountRepo implements AccountInfo {
  final LocalStorageAbstractProvider localProvider;
  final CryptographyKeyGenerator cryptographyKeyGenerator;

  AccountRepo(
      {required this.localProvider, required this.cryptographyKeyGenerator});

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
  Future<void> createAccountAndSaveInStorage() async {
    // we save the credentials in the key chain
    final result = await compute(_createAccount, null);

    await saveCredentials(
      result.coreId,
      result.privateKey,
      null,
      result.phrases,
      result.address,
      result.pubKey,
    );
  }

  Future<_CreateAccountResult> _createAccount(_) async {
    // generate the mnemonic from the cryptographyKeyGenerator
    final phrases = cryptographyKeyGenerator.generate_mnemonic();
    // generate the private key from the cryptographyKeyGenerator using the mnemonic and a password
    final privateKey = await cryptographyKeyGenerator
        .generatePrivateKeysFromMneomonic(phrases, "198491");

    final address = await cryptographyKeyGenerator.generateAddress(privateKey);
    final pubKey =
        await cryptographyKeyGenerator.getPublicKeyFromPrivate(privateKey);
    final coreId =
        await cryptographyKeyGenerator.generateCoreIdFromPriv(privateKey);
    return _CreateAccountResult(
      address: address,
      coreId: coreId,
      phrases: phrases,
      privateKey: privateKey,
      pubKey: pubKey,
    );
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
    await localProvider.saveToStorage(
        CRED_KEY_IN_STORE, jsonEncode(credentials));
  }

  @override
  Future<String?> getLocalCoreId() async {
    final credentialInLocalStorage =
        await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (credentialInLocalStorage == null) {
      return null;
    } else {
      final previousCredential =
          (jsonDecode(credentialInLocalStorage) as Map<String, dynamic>);
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

  @override
  Future<String?> getCorePassCoreId() async {
    return localProvider.readFromStorage(COREPASS_ID);
  }

  @override
  Future<void> setCorePassCoreId(String coreId) async {
    await localProvider.saveToStorage(COREPASS_ID, coreId);
  }

  @override
  Future<String?> getSignature() async {
    return localProvider.readFromStorage(COREPASS_SIGNATURE);
  }

  @override
  Future<void> setSignature(String signature) async {
    await localProvider.saveToStorage(COREPASS_SIGNATURE, signature);
  }

  @override
  Future<String?> getPublicKey() async {
    final prevs = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (prevs == null) {
      return null;
    } else {
      final previousCreds = ((jsonDecode(prevs) as Map<String, dynamic>));
      return previousCreds[PUBLIC_KEY] as String?;
    }
  }
}

class _CreateAccountResult {
  final String coreId;
  final String privateKey;
  final List<String> phrases;
  final String address;
  final String pubKey;

  _CreateAccountResult({
    required this.coreId,
    required this.privateKey,
    required this.phrases,
    required this.address,
    required this.pubKey,
  });
}

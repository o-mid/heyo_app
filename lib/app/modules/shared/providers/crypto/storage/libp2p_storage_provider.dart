import 'dart:convert';

import 'package:heyo/app/modules/shared/data/providers/secure_storage/local_storages_abstract.dart';


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

class LibP2PStorageProvider {
  LibP2PStorageProvider({required this.localProvider});

  final LocalStorageAbstractProvider localProvider;

  Future<void> saveCredentials(String coreId, String privateKey, String? aesKey,
      List<String> mneomns, String address, String publicKey) async {
    final credentials = <String, dynamic>{
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

  Future<String?> getLocalCoreId() async {
    final credentialInLocalStorage =
        await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (credentialInLocalStorage == null) {
      return null;
    } else {
      final previousCredential =
          jsonDecode(credentialInLocalStorage) as Map<String, dynamic>;
      return previousCredential[CORE_ID_KEY_IN_STORE] as String?;
    }
  }

  Future<String?> getPrivateKey() async {
    final prevs = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (prevs == null) {
      return null;
    } else {
      final previousCreds = jsonDecode(prevs) as Map<String, dynamic>;
      return previousCreds[PRIV_KEY_IN_STORE] as String?;
    }
  }

  Future<String?> getCorePassCoreId() async {
    return localProvider.readFromStorage(COREPASS_ID);
  }

  Future<void> setCorePassCoreId(String coreId) async {
    await localProvider.saveToStorage(COREPASS_ID, coreId);
  }

  Future<void> removeCorePassCoreId() async {
    await localProvider.deleteFromStorage(COREPASS_ID);
  }

  Future<String?> getSignature() async {
    return localProvider.readFromStorage(COREPASS_SIGNATURE);
  }

  Future<void> setSignature(String signature) async {
    await localProvider.saveToStorage(COREPASS_SIGNATURE, signature);
  }

  Future<void> removeSignature() async {
    await localProvider.deleteFromStorage(COREPASS_SIGNATURE);
  }

  Future<String?> getPublicKey() async {
    final prevs = await localProvider.readFromStorage(CRED_KEY_IN_STORE);
    if (prevs == null) {
      return null;
    } else {
      final previousCreds = jsonDecode(prevs) as Map<String, dynamic>;
      return previousCreds[PUBLIC_KEY] as String?;
    }
  }

  @override
  Future<String?> getP2PSecret() async {
    final p2pSecret = await localProvider.readFromStorage(P2P_KEY_IN_STORE);
    return p2pSecret;
  }

  @override
  Future<void> setP2PSecret(String p2pSecret) async {
    await localProvider.saveToStorage(P2P_KEY_IN_STORE, p2pSecret);
  }
}

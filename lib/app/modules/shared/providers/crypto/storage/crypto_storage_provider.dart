import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_crypto_storage_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

abstract class CryptoStorageProvider {

  Future<void> saveCredentials(String coreId, String privateKey, String? aesKey,
      List<String> mneomns, String address, String publicKey);

  Future<String?> getPrivateKey();

  Future<String?> getLocalCoreId();

  Future<String?> getCorePassCoreId();

  Future<void> setCorePassCoreId(String coreId);

  Future<void> setSignature(String signature);

  Future<void> removeSignature();

  Future<String?> getSignature();

  Future<String?> getPublicKey();

  Future<void> removeCorePassCoreId();

  Future<String?> getP2PSecret();

  Future<void> setP2PSecret(String p2pSecret);
}

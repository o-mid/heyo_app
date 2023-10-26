abstract class AccountInfo {
  Future<void> createAccountAndSaveInStorage();

  Future<String?> getP2PSecret();

  Future<void> setP2PSecret(String p2pSecret);

  Future<void> saveCredentials(String coreId, String privateKey, String aesKey,
      List<String> mneomns, String address, String publicKey);

  Future<String?> getLocalCoreId();

  Future<String?> getPrivateKey();

  Future<String?> getCorePassCoreId();

  Future<void> setCorePassCoreId(String coreId);

  Future<void> setSignature(String signature);

  Future<String?> getSignature();

  Future<String?> getPublicKey();
}

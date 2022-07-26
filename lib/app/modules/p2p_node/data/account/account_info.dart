abstract class AccountInfo {
  Future<void> createAccountAndSaveInStorage();

  Future<String?> getP2PSecret();

  Future<void> setP2PSecret(String p2pSecret);

  Future<void> saveCredentials(String coreId, String privateKey, String aesKey,
      List<String> mneomns, String address, String publicKey);

  Future<String?> getCoreId();

  Future<String?> getPrivateKey();
}

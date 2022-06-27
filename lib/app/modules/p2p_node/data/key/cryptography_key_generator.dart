
abstract class CryptographyKeyGenerator {
  List<String> generate_mnemonic();

  Future<String> generatePrivateKeysFromMneomonic(
      List<String> phrases, String pinCode);

  Future<String> generateAddress(String privateKey);

  Future<String> generateCoreIdFromPriv(String privateKey);

  Future<String> getPublicKeyFromPrivate(String privKey);
}

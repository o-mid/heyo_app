import 'package:heyo/app/modules/p2p_node/auth_keys_model.dart';

abstract class CryptographyKeyGenerator {
  List<String> generate_mnemonic();

  Future<KeysModel> generatePrivateKeysFromMneomonic(
      List<String> phrases, String pinCode);

  Future<String> generateAddress(String privateKey);

  Future<String> generateCoreIdFromPriv(String privateKey);

  Future<String> getPublicKeyFromPrivate(String privKey);

  String generateSHA3Hash(String txt);
}

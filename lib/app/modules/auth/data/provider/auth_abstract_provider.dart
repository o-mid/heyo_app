import 'dart:math';

import 'package:core_web3dart/credentials.dart';

abstract class AuthAbstractProvider {
  String generateMnemonics();
  XCBPrivateKey generatePrivateKeyFromMnemonic(String seed, int index);
  Wallet createWalletFromCredentials(XCBPrivateKey privateKey, String password, Random random);
  String getPublicKeyFromPrivate(String privateKey);
  String getAddressFromPrivateKey(String privateKey, int networkId);
}

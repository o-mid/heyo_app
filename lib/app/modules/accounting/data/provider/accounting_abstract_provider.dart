import 'dart:math';

import 'package:core_web3dart/credentials.dart';

abstract class AccountingAbstractProvider {
  String generateMnemonics();
  XCBPrivateKey generatePrivateKeyFromMnemonic(String seed, int index);
  Wallet createWalletFromCredentials(XCBPrivateKey privateKey, String password, Random random);
}

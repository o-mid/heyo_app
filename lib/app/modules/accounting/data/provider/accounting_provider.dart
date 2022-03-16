import 'dart:math';

import 'package:core_web3dart/src/credentials/credentials.dart';
import 'package:core_web3dart/src/credentials/wallet.dart';
import 'package:heyo/app/modules/accounting/data/provider/accounting_abstract_provider.dart';
import 'package:flutter_bip39/bip39.dart';

class AccountingProvider implements AccountingAbstractProvider {
  @override
  String generateMnemonics() {
    return generateMnemonic();
  }

  @override
  XCBPrivateKey generatePrivateKeyFromMnemonic(String seed, int index) {
    return XCBPrivateKey.createPrivateKey(seed, index);
  }

  @override
  Wallet createWalletFromCredentials(XCBPrivateKey privateKey, String password, Random random) {
    return Wallet.createNew(privateKey, password, random);
  }
}

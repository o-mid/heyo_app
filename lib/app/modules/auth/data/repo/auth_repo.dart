import 'dart:math';

import 'package:core_web3dart/src/credentials/credentials.dart';
import 'package:core_web3dart/src/credentials/wallet.dart';
import 'package:heyo/app/modules/auth/data/provider/auth_abstract_provider.dart';
import 'package:heyo/app/modules/auth/data/repo/auth_abstract_repo.dart';

class AuthRepo implements AuthAbstractRepo {
  AuthAbstractProvider provider;

  AuthRepo({required this.provider});

  @override
  String generateMnemonics() {
    return provider.generateMnemonics();
  }

  @override
  XCBPrivateKey generatePrivateKeyFromMnemonic(String seed, int index) {
    return provider.generatePrivateKeyFromMnemonic(seed, index);
  }

  @override
  Wallet createWalletFromCredentials(XCBPrivateKey privateKey, String password, [Random? random]) {
    return provider.createWalletFromCredentials(privateKey, password, random ?? Random.secure());
  }

  @override
  String getPublicKeyFromPrivate(String privateKey) {
    return provider.getPublicKeyFromPrivate(privateKey);
  }

  @override
  String getAddressFromPrivateKey(String privateKey, int networkId) {
    return provider.getAddressFromPrivateKey(privateKey, networkId);
  }
}

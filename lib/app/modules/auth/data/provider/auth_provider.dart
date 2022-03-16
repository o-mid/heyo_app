import 'dart:math';

import 'package:heyo/app/modules/auth/data/provider/auth_abstract_provider.dart';
import 'package:flutter_bip39/bip39.dart';
import 'package:core_web3dart/crypto.dart';
import 'package:core_web3dart/web3dart.dart';

class AuthProvider implements AuthAbstractProvider {
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

  @override
  String getPublicKeyFromPrivate(String privateKey) {
    return bytesToHex(privateKeyBytesToPublic(hexToBytes(privateKey)));
  }

  @override
  String getAddressFromPrivateKey(String privateKey, int networkId) {
    final publicKey = getPublicKeyFromPrivate(privateKey);
    return bytesToHex(publicKeyToAddress(hexToBytes(publicKey), networkId));
  }
}

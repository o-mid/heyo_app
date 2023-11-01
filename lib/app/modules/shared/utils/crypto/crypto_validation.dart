import 'package:flutter/foundation.dart';
import 'package:flutter_ed448/src/HDWallets/ed448_hd_wallets.dart';

class CryptoValidation {
  final _ed448Wallet = Ed448HDWallet();

  bool validateSignature(
      Uint8List messageHash, Uint8List signedMsg, Uint8List publicKey) {
    try {
      final verifyResult =
          _ed448Wallet.ed448Verify(publicKey, messageHash, signedMsg);
      return verifyResult;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_ed448/src/HDWallets/ed448_hd_wallets.dart';

class CryptoValidation {
  final _ed448Wallet = Ed448HDWallet();

  bool validateSignature(
      Uint8List messageHash, Uint8List signedMsg, Uint8List publicKey) {
    try {
      final extractedSign = <int>[];
      for (var i = 0; i < 114; i++) {
        extractedSign.add(signedMsg[i]);
      }
      final verifyResult = _ed448Wallet.ed448Verify(
          publicKey, messageHash, Uint8List.fromList(extractedSign));
      return verifyResult;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/crypto_abstract_provider.dart';
import 'package:heyo/app/modules/shared/utils/crypto/crypto_validation.dart';

class CryptoProvider extends CryptoAbstractProvider {
  CryptoProvider({required this.cryptoValidation});

  CryptoValidation cryptoValidation;

  @override
  bool validateSignature(
      String messageHash, String signedMsg, String publicKey) {
    return cryptoValidation.validateSignature(
      Uint8List.fromList(messageHash.codeUnits),
      Uint8List.fromList(signedMsg.codeUnits),
      Uint8List.fromList(publicKey.codeUnits),
    );
  }
}

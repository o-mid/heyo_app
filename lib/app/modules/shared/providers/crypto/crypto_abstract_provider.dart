import 'package:flutter/foundation.dart';

abstract class CryptoAbstractProvider {
  bool validateSignature(
    String messageHash,
    String signedMsg,
    String publicKey,
  );
}

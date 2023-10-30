import 'package:flutter/foundation.dart';

abstract class SplashAbstractRepositoy {
  bool isSignatureValid(
    String messageHash,
    String signedMsg,
    String publicKey,
  );
}

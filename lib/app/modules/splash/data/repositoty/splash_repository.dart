import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/crypto_provider.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_abstract_repository.dart';

class SplashRepository extends SplashAbstractRepositoy {
  CryptoProvider cryptoProvider;

  SplashRepository({required this.cryptoProvider,});

  @override
  bool isSignatureValid(
    String messageHash,
    String signedMsg,
    String publicKey,
  ) {
    return cryptoProvider.validateSignature(messageHash, signedMsg, publicKey);
  }
}

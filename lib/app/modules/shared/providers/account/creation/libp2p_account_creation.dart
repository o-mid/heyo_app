import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/crypto_storage_provider.dart';

class LibP2PAccountCreation extends AccountCreation {
  final LocalStorageAbstractProvider localProvider;
  final CryptographyKeyGenerator cryptographyKeyGenerator;
  final CryptoStorageProvider cryptoInfoProvider;

  LibP2PAccountCreation({
    required this.localProvider,
    required this.cryptographyKeyGenerator,
    required this.cryptoInfoProvider,
  });

  @override
  Future<CreateAccountResult> createAccount() async {
    final result = await compute(_createAccount, null);
    return result;
  }

  @override
  Future<void> saveAccount(CreateAccountResult accountResult) async {
    await cryptoInfoProvider.saveCredentials(
      accountResult.coreId,
      accountResult.privateKey,
      null,
      accountResult.phrases,
      accountResult.address,
      accountResult.pubKey,
    );
  }

  Future<CreateAccountResult> _createAccount(_) async {
    // generate the mnemonic from the cryptographyKeyGenerator
    final phrases = cryptographyKeyGenerator.generate_mnemonic();
    // generate the private key from the cryptographyKeyGenerator using the mnemonic and a password
    final privateKey = await cryptographyKeyGenerator
        .generatePrivateKeysFromMneomonic(phrases, "198491");

    final address = await cryptographyKeyGenerator.generateAddress(privateKey);
    final pubKey =
        await cryptographyKeyGenerator.getPublicKeyFromPrivate(privateKey);
    final coreId =
        await cryptographyKeyGenerator.generateCoreIdFromPriv(privateKey);
    return CreateAccountResult(
      address: address,
      coreId: coreId,
      phrases: phrases,
      privateKey: privateKey,
      pubKey: pubKey,
    );
  }
}



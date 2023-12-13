import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'dart:isolate';

class LibP2PAccountCreation extends AccountCreation {
  final LocalStorageAbstractProvider localProvider;
  final CryptographyKeyGenerator cryptographyKeyGenerator;
  final LibP2PStorageProvider libp2pStorage;

  LibP2PAccountCreation({
    required this.localProvider,
    required this.cryptographyKeyGenerator,
    required this.libp2pStorage,
  });

  @override
  Future<CreateAccountResult> createAccount() async {
    return compute((_) => _createAccount(), null);
  }

  @override
  Future<void> saveAccount(CreateAccountResult accountResult) async {
    await libp2pStorage.saveCredentials(
      accountResult.coreId,
      accountResult.privateKey,
      null,
      accountResult.phrases,
      accountResult.address,
      accountResult.pubKey,
    );
  }
}

Future<CreateAccountResult> _createAccount() async {
  // generate the mnemonic from the cryptographyKeyGenerator

  final cryptographyKeyGenerator =
      Web3Keys(web3client: GlobalBindings.web3Client);

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
    coreId: coreId,
    privateKey: privateKey,
    phrases: phrases,
    address: address,
    pubKey: pubKey,
  );
}

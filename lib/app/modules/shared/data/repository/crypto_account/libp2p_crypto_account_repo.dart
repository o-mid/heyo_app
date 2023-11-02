import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/account_types.dart';
import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/crypto_account_repo.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/crypto_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/crypto/crypto_validation.dart';

class LibP2PCryptoAccountRepository extends CryptoAccountRepository {
  LibP2PCryptoAccountRepository(
      {required this.accountCreation, required this.cryptoInfoProvider});

  CryptoValidation cryptoValidation = CryptoValidation();
  AccountCreation accountCreation;
  CryptoStorageProvider cryptoInfoProvider;

  @override
  AccountTypes accountType() {
    return AccountTypes.libP2P;
  }

  @override
  Future<CreateAccountResult> createAccount() {
    return accountCreation.createAccount();
  }

  @override
  Future<void> saveAccount(CreateAccountResult account) async {
    await accountCreation.saveAccount(account);
  }

  @override
  Future<bool> hasAccount() async {
    final signature = await cryptoInfoProvider.getSignature();
    final localCoreId = await cryptoInfoProvider.getLocalCoreId();
    final publicKey = await cryptoInfoProvider.getPublicKey();
    return signature != null;
    // if (signature == null || localCoreId == null) return false;
    //
    //
    // return cryptoValidation.validateSignature(
    //   hexToBytes(publicKey!),
    //   hexToBytes(localCoreId!),
    //   hexToBytes(signature!),
    // );
  }

  @override
  Future<String?> getUserDefaultAddress() {
    return cryptoInfoProvider.getLocalCoreId();
  }

  @override
  Future<String?> getUserContactAddress() {
    return cryptoInfoProvider.getCorePassCoreId();
  }

  Uint8List _ecRecover(Uint8List signedMessage) {
    List<int> pubKey = [];
    for (var i = 114; i < signedMessage.length; i++) {
      pubKey.add(signedMessage[i]);
    }
    return Uint8List.fromList(pubKey);
  }

  @override
  RxBool isLoggedIn = false.obs;

  @override
  RxBool onAccountStateChanged() {
    return isLoggedIn;
  }

  @override
  Future<void> logout() async {
    await cryptoInfoProvider.removeCorePassCoreId();
    await cryptoInfoProvider.removeSignature();
    isLoggedIn.value = false;
  }
}

import 'dart:async';
import 'dart:ffi';

import 'package:heyo/app/modules/shared/data/models/account_types.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/utils/crypto/crypto_validation.dart';

const String ACCOUNT_TYPE = 'account_type';

class AppAccountRepository extends AccountRepository {
  AppAccountRepository({
    required this.libP2PStorageProvider,
    required this.localStorageProvider,
  });

  CryptoValidation cryptoValidation = CryptoValidation();
  LibP2PStorageProvider libP2PStorageProvider;
  LocalStorageAbstractProvider localStorageProvider;

  @override
  Future<bool> saveAccountType(AccountTypes type) {
    return localStorageProvider.saveToStorage(ACCOUNT_TYPE, type.name);
  }

  @override
  Future<AccountTypes?> accountType() async {
    final name = await localStorageProvider.readFromStorage(ACCOUNT_TYPE);
    try {
      return AccountTypes.values.byName(name ?? '');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> hasAccount() async {
    final type = await accountType();
    switch (type) {
      case AccountTypes.libP2P:
        final signature = await libP2PStorageProvider.getSignature();
        final isLogin = signature != null && signature.isNotEmpty;
        isLoggedIn.add(isLogin);
        return isLogin;
      case null:
        return false;
    }
  }

  @override
  Future<String?> getUserAddress() async {
    final type = await accountType();
    return switch (type) {
      AccountTypes.libP2P => libP2PStorageProvider.getCorePassCoreId(),
      null => null,
    };
  }

  @override
  Stream<bool> onAccountStateChanged() {
    return isLoggedIn.stream;
  }

  @override
  Future<void> logout() async {
    final type = await accountType();
    switch (type) {
      case AccountTypes.libP2P:
        await libP2PStorageProvider.removeCorePassCoreId();
        await libP2PStorageProvider.removeSignature();
      case null:
    }
    isLoggedIn.add(false);
  }
}

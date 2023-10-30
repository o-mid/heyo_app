import 'package:heyo/app/modules/shared/data/models/account_types.dart';
import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/libp2p_crypto_account_repo.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/crypto_storage_provider.dart'
    as crypto_account;

abstract class CryptoAccountRepository {
  factory CryptoAccountRepository({
    required String type,
    required AccountCreation accountCreation,
    required crypto_account.CryptoStorageProvider cryptoInfoProvider,
  }) {
    return LibP2PCryptoAccountRepository(
      accountCreation: accountCreation,
      cryptoInfoProvider: cryptoInfoProvider,
    );
  }

  Future<bool> hasAccount();

  AccountTypes accountType();

  Future<CreateAccountResult> createAccount();

  Future saveAccount(CreateAccountResult account);

  Future<String?> getUserDefaultAddress();

  Future<String?> getUserContactAddress();
}

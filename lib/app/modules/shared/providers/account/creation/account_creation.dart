import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/crypto_storage_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

abstract class AccountCreation {

  Future<CreateAccountResult> createAccount();

  Future<void> saveAccount(CreateAccountResult accountResult);


}

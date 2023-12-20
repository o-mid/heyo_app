import 'package:heyo/app/modules/shared/data/models/create_account_result.dart';

abstract class AccountCreation {

  Future<CreateAccountResult> createAccount();

  Future<void> saveAccount(CreateAccountResult accountResult);


}

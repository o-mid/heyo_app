import 'dart:async';
import 'package:heyo/app/modules/shared/data/models/account_types.dart';

abstract class AccountRepository {
  final StreamController<bool> isLoggedIn = StreamController();

  Future<bool> saveAccountType(AccountTypes type);

  Future<bool> hasAccount();

  Future<AccountTypes?> accountType();

  Future<String?> getUserAddress();

  Stream<bool> onAccountStateChanged();

  Future<void> logout();
}

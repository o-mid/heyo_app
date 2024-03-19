import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/account/app_account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class AccountInjector with HighPriorityInjector, NormalPriorityInjector {
  @override
  void executeHighPriorityInjector() {
    inject.registerSingleton<AccountRepository>(
      AppAccountRepository(
        libP2PStorageProvider: inject.get(),
        localStorageProvider: inject.get(),
      ),
    );
  }

  @override
  void executeNormalPriorityInjector() {
    inject
      ..registerSingleton(
        ContactRepository(
          cacheContractor: inject.get(),
        ),
      )
      ..registerSingleton<AccountCreation>(
        LibP2PAccountCreation(
          localProvider: inject.get(),
          cryptographyKeyGenerator: Web3Keys(web3client: inject.get()),
          libp2pStorage: inject.get(),
        ),
      )
      ..registerSingleton(
        AccountController(
          accountInfoRepo: inject.get(),
        ),
      );
  }
}

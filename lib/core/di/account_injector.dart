import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/account/app_account_repository.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

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
      ..registerSingleton<ContactRepo>(
        LocalContactRepo(
          cacheContractor: inject.get(),
        ),
      )
      ..registerSingleton<LocalContactRepo>(
        LocalContactRepo(
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

import 'package:get/get.dart';
import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/account/app_account_repository.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

import '../controllers/user_preview_controller.dart';

class AccountBindings with HighPriorityBindings, NormalPriorityBindings {
  @override
  void executeHighPriorityBindings() {
    Get.put<AccountRepository>(
      AppAccountRepository(
        libP2PStorageProvider: Get.find(),
        localStorageProvider: Get.find(),
      ),
      permanent: true,
    );
  }

  @override
  void executeNormalPriorityBindings() {
    Get
      ..put<ContactRepo>(
        LocalContactRepo(
          appDatabaseProvider: inject.get<AppDatabaseProvider>(),
        ),
      )
      ..put<LocalContactRepo>(
        LocalContactRepo(
          appDatabaseProvider: inject.get<AppDatabaseProvider>(),
        ),
      )
      ..put<AccountCreation>(
        LibP2PAccountCreation(
          localProvider: Get.find(),
          cryptographyKeyGenerator: Web3Keys(web3client: Get.find()),
          libp2pStorage: Get.find(),
        ),
      )
      ..put(AccountController(accountInfoRepo: Get.find()));
  }
}

import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class StorageInjector with HighPriorityInjector {
  @override
  void executeHighPriorityInjector() {
    inject
      ..registerSingleton(
        AppDatabaseProvider(),
        //permanent: true,
      )
      ..registerSingleton<LocalStorageAbstractProvider>(
        SecureStorageProvider(),
      )
      ..registerSingleton<LibP2PStorageProvider>(
        LibP2PStorageProvider(
          localProvider: inject.get(),
        ),
      )
      ..registerSingleton<UserProvider>(
        UserProvider(appDatabaseProvider: inject.get()),
      )
      ..registerSingleton<CacheContractor>(
        CacheRepository(userProvider: inject.get()),
      );
  }
}

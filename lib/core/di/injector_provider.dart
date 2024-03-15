import 'package:get_it/get_it.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

final GetIt inject = GetIt.instance;

Future<void> setupInjection() async {
  // Register dependencies first
  inject
    ..registerSingleton<AppDatabaseProvider>(AppDatabaseProvider())
    ..registerSingleton<UserProvider>(
      UserProvider(appDatabaseProvider: inject.get()),
    )
    ..registerSingleton<CacheContractor>(
      CacheRepository(userProvider: inject.get()),
    )
    ..registerSingleton<CallHistoryAbstractProvider>(
      CallHistoryProvider(appDatabaseProvider: inject.get()),
    )
    ..registerSingleton<ContactRepository>(
      ContactRepository(cacheContractor: inject.get()),
    )
    ..registerSingleton<ContactNameUseCase>(
      ContactNameUseCase(contactRepository: inject.get()),
    )

    // Register repositories and use cases
    ..registerSingleton<CallHistoryRepo>(
      CallHistoryRepo(callHistoryProvider: inject.get()),
    );
}

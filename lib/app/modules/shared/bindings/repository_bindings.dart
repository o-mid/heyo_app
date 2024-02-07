import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

class RepositoryBindings with NormalPriorityBindings {
  @override
  void executeNormalPriorityBindings() {
    Get.put(
      ContactRepository(
        cacheContractor: CacheRepository(
          userProvider: UserProvider(
            appDatabaseProvider: Get.find<AppDatabaseProvider>(),
          ),
        ),
      ),
    );
  }
}

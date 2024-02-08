import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';

class StorageBindings with HighPriorityBindings {
  @override
  void executeHighPriorityBindings() {
    Get
      ..put(AppDatabaseProvider(), permanent: true)
      ..put<LocalStorageAbstractProvider>(
        SecureStorageProvider(),
      )
      ..put<LibP2PStorageProvider>(
        LibP2PStorageProvider(
          localProvider: Get.find(),
        ),
      );
  }
}

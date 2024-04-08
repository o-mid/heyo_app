import 'package:get/get.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class WifiDirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiDirectController>(
      () => WifiDirectController(
        accountInfoRepo: Get.find(),
        // wifiDirectConnectionController: Get.find<UnifiedConnectionController>(),
        contactRepository: inject.get<ContactRepo>(),
      ),
    );
  }
}

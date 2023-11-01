import 'package:get/get.dart';

import 'package:heyo/app/modules/intro/controllers/intro_controller.dart';
import 'package:heyo/app/modules/intro/data/provider/verification_corepass_provider.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_repo.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/store/store_provider.dart';
import 'package:heyo/app/modules/shared/utils/datetime_utils.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(
      () => IntroController(
        introRepo: IntroRepo(
          vcp: VerificationCorePassProvider(
            accountInfo: GlobalBindings.accountInfo,
            dateTimeUtils: DateTimeUtils(),
            p2pNodeController: Get.find(),
          ),
          storeProvider: StoreProvider(),
        ),
        p2pState: Get.find(),
      ),
    );
  }
}

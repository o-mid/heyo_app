import 'package:get/get.dart';

import 'package:heyo/app/modules/intro/controllers/intro_controller.dart';
import 'package:heyo/app/modules/intro/data/provider/verification_corepass_provider.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_repo.dart';
import 'package:heyo/app/modules/intro/usecase/verification_with_corepass_use_case.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
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
            p2pCommunicator: GlobalBindings.p2pCommunicator,
            dateTimeUtils: DateTimeUtils(),
          ),
          storeProvider: StoreProvider(),
        ), p2pState: GlobalBindings.p2pState,
      ),
    );
  }
}

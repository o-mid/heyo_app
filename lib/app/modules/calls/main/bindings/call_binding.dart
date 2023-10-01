import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        callRepository: WebRTCCallRepository(
          callConnectionsHandler: Get.find(),
        ),
        accountInfo: AccountRepo(
          localProvider: SecureStorageProvider(),
          cryptographyKeyGenerator: Web3Keys(
            web3client: GlobalBindings.web3Client,
          ),
        ),
      ),
    );
  }
}

import 'package:get/get.dart';

import 'package:heyo/app/modules/intro/controllers/intro_controller.dart';
import 'package:heyo/app/modules/intro/usecase/verification_with_corepass_use_case.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(
      () => IntroController(
        verificationWithCorePassUseCase: VerificationWithCorePassUseCase(
          accountInfo: AccountRepo(
            localProvider: SecureStorageProvider(),
            cryptographyKeyGenerator: Web3Keys(
              web3client: GlobalBindings.web3Client,
            ),
          ),
        ),
      ),
    );
  }
}

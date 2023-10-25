import 'package:flutter/cupertino.dart';
import 'package:heyo/app/modules/intro/data/provider/verification_corepass_abstract_provider.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_abstract_repo.dart';
import 'package:heyo/app/modules/shared/providers/store/store_abstract_provider.dart';
import 'package:tuple/tuple.dart';

class IntroRepo extends IntroAbstractRepo {
  VerificationCorePassAbstractProvider vcp;
  StoreAbstractProvider storeProvider;

  IntroRepo({required this.vcp, required this.storeProvider});

  @override
  Future<Tuple3<bool, String, String>> retrieveCoreIdFromCorePass() async {
    final isLaunched = await vcp.launchVerificationProcess();

    /// in this case, we should launch appstore to download corepass
    if (!isLaunched) return const Tuple3(false, '', '');

    final corePassData = await vcp.listenForResponse();
    return Tuple3(true, corePassData.item1, corePassData.item2);
  }

  @override
  bool launchStore() => storeProvider.launchStoreForUri('');

  @override
  Future<bool> applyDelegatedCredentials(
      String coreId, String signature) async {
    final isSuccessful = await vcp.applyDelegatedCredentials(coreId, signature);
    vcp.setDelegationStatus(status: isSuccessful);
    if (isSuccessful) await vcp.cleanUp();
    debugPrint('Delegated Credentials Successfully added');
    return isSuccessful;
  }
}

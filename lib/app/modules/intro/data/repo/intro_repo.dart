import 'package:flutter/cupertino.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/intro/data/provider/verification_corepass_abstract_provider.dart';
import 'package:heyo/app/modules/intro/data/repo/intro_abstract_repo.dart';
import 'package:heyo/app/modules/shared/data/models/account_types.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/providers/store/store_abstract_provider.dart';
import 'package:tuple/tuple.dart';

class IntroRepo extends IntroAbstractRepo {
  VerificationCorePassAbstractProvider vcp;
  StoreAbstractProvider storeProvider;
  AccountRepository accountRepository;
  ConnectionContractor connectionContractor;

  IntroRepo(
      {required this.connectionContractor,
      required this.vcp,
      required this.storeProvider,
      required this.accountRepository});

  @override
  Future<Tuple3<bool, String, String>> retrieveCoreIdFromCorePass() async {
    await connectionContractor.init();

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
    final isSuccessful = await vcp.setCredentials(coreId, signature);
    if (isSuccessful) {
      await vcp.cleanUp();
      await accountRepository.saveAccountType(AccountTypes.libP2P);
    }
    debugPrint('Delegated Credentials Successfully added');
    return isSuccessful;
  }
}

import 'dart:convert';

import 'package:heyo/app/modules/shared/data/repository/info/crypto_account_repo.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

class QRInfo {
  final AccountInfoRepository accountInfoRepo;
  final P2PState p2pState;

  QRInfo({required this.p2pState, required this.accountInfoRepo});

  Future<String> getSharableQr() async {
    var coreId = await accountInfoRepo.getUserContactAddress();
    if (coreId == null) throw 'core Id is null!!';

    return coreId +
        SHARED_ADDR_SEPARATOR +
        p2pState.peerId.value +
        SHARED_ADDR_SEPARATOR +
        jsonEncode(p2pState.address.value);
  }

  Future<String?> getCoreId() {
    return accountInfoRepo.getUserContactAddress();
  }
}

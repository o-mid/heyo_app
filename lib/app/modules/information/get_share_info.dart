import 'dart:convert';

import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

class QRInfo {
  final AccountInfo accountInfo;
  final P2PState p2pState;


  QRInfo({required this.p2pState, required this.accountInfo});

  Future<String> getSharableQr() async {

    String? _coreId = await accountInfo.getCoreId();
    if (_coreId == null) throw 'core Id is null!!';
    
    return _coreId +
        SHARED_ADDR_SEPARATOR +
        p2pState.peerId.value +
        SHARED_ADDR_SEPARATOR +
        jsonEncode(p2pState.address.value);
  }
}

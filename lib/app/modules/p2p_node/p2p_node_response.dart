import 'dart:async';

import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';

class P2PNodeResponseStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeResponseSubscription;

  void setUp() {
    _setUpResponseStream();
  }

  void reset() {
    _nodeResponseSubscription?.cancel();
    _nodeResponseSubscription = null;
  }

  _setUpResponseStream() {
    _nodeResponseSubscription ??= FlutterP2pCommunicator.responseStream
        ?.distinct()
        .where((event) => event != null)
        .listen((event) async {
      _onNewResponseEvent(event!);
    });
  }

  _onNewResponseEvent(P2PReqResNodeModel event) async {
    print("_onNewResponseEvent : eventName is: ${event.name.toString()}");
    if (event.name == P2PReqResNodeNames.login && event.error == null) {
      // this means the login was successfully sent
      //loginState.value = P2P_STATE.SUCCESS;
    } else if (event.name == P2PReqResNodeNames.connect &&
        event.error == null) {
      final _info = P2PReqResNodeModel(name: P2PReqResNodeNames.advertise);
      final _id = await FlutterP2pCommunicator.sendRequest(info: _info);
      /* -------------------------------------------------------------------------- */
      /*                                  get addrs                                 */
      /* -------------------------------------------------------------------------- */
      await FlutterP2pCommunicator.sendRequest(
          info: P2PReqResNodeModel(name: P2PReqResNodeNames.peerID));
      await FlutterP2pCommunicator.sendRequest(
          info: P2PReqResNodeModel(name: P2PReqResNodeNames.addrs));
    }
  }
}

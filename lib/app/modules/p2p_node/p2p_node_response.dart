import 'dart:async';

import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeResponseStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeResponseSubscription;
  bool advertised = false;
  final P2PState p2pState;

  P2PNodeResponseStream({required this.p2pState});

  void setUp() {
    _setUpResponseStream();
  }

  void reset() {
    advertised = false;
    p2pState.responses = [];
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
    p2pState.responses.add(event);

    print("_onNewResponseEvent : eventName is: ${event.name.toString()}");
    if (event.name == P2PReqResNodeNames.login) {
      if(event.error == null) {
        p2pState.loginState.value=P2P_STATUS.SUCCESS;
      } else {
        p2pState.loginState.value=P2P_STATUS.ERROR;
      }
      // this means the login was successfully sent
      //loginState.value = P2P_STATE.SUCCESS;
    } else if (event.name == P2PReqResNodeNames.connect &&
        event.error == null &&
        !advertised) {
      final _info = P2PReqResNodeModel(name: P2PReqResNodeNames.advertise);
      advertised = true;
      final _id = await FlutterP2pCommunicator.sendRequest(info: _info);
      /* -------------------------------------------------------------------------- */
      /*                                  get addrs                                 */
      /* -------------------------------------------------------------------------- */
      await FlutterP2pCommunicator.sendRequest(
          info: P2PReqResNodeModel(name: P2PReqResNodeNames.peerID));
      await FlutterP2pCommunicator.sendRequest(
          info: P2PReqResNodeModel(name: P2PReqResNodeNames.addrs));
    } else if (event.name == P2PReqResNodeNames.advertise &&
        event.error == null) {
      // now you can start talking or communicating to others
    } else if (event.name == P2PReqResNodeNames.addrs && event.error == null) {
      p2pState.address.value = (event.body!["addrs"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }
    if (event.name == P2PReqResNodeNames.peerID && event.error == null) {
      p2pState.peerId.value = event.body!["peerID"].toString();
    }
  }
}

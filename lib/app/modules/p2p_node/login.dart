import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/login_mode.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/model/transfer_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

class Login {
  final P2PState p2pState;
  final AccountInfo accountInfo;

  Login({required this.p2pState, required this.accountInfo});

  Future<String> _sendingConnectRequest(P2PAddrModel info) async {
    final id = await FlutterP2pCommunicator.sendRequest(
        info: P2PReqResNodeModel(
            name: P2PReqResNodeNames.connect, body: info.toJson()));

    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: RETRY_DELAY));
      final _ids = p2pState.responses.map((e) => e.id).toList();
      final _isAvailable = _ids.contains(id);
      return !_isAvailable;
    });
    return id;
  }

  void execute(String? barcodeValue) async {
    if (barcodeValue == null) {
      return; // Todo(qr)
    }
    final localCoreId = await accountInfo.getCoreId();
    if (localCoreId == null) throw 'Core id is null!!';

    final remoteCoreId = barcodeValue.getCoreId();
    final remotePeerId = barcodeValue.getPeerId();
    final addresses = barcodeValue.getAddresses();

    //TODO ask moji about name and connect usecase in general
    final connected =
        await _connect(P2PAddrModel(id: remotePeerId, addrs: addresses));
    //TODO session
    final _loginModel = P2PLoginBodyModel(
        info: connected
            ? P2PTransferModel(
                localCoreID: localCoreId,
                remotePeerID: remotePeerId,
                remoteCoreID: remoteCoreId)
            : P2PTransferModel(
                localCoreID: localCoreId, remoteCoreID: remoteCoreId),
        payload: P2PLoginPayloadModel(session: "0x73"));
    _sendingLoginRequest(_loginModel);
  }


  Future<void> _sendingLoginRequest(dynamic model) async {
    int retryCount = 0;
    await Future.doWhile(() async {
      p2pState.loginState.value = P2P_STATUS.IN_PROGRESS;
      retryCount++;
      await FlutterP2pCommunicator.sendRequest(
          info: P2PReqResNodeModel(
              name: P2PReqResNodeNames.login, body: model.toJson()));
      print("login request counter is:$retryCount");
      await Future.delayed(const Duration(seconds: 5));
      if (p2pState.loginState.value == P2P_STATUS.SUCCESS) {
        return false;
      } else {
        if (retryCount > RETRY_NUMBER) {
          p2pState.loginState.value = P2P_STATUS.ERROR;
          return false;
        } else {
          return true;
        }
      }
    });
  }

  P2PReqResNodeModel? _gettingConnectResponse(String id) {
    P2PReqResNodeModel? _res;
    try {
      _res = p2pState.responses.singleWhereOrNull((element) =>
          element.id == id && element.name == P2PReqResNodeNames.connect);
    } catch (e) {
      print("error in tryConnect ${e.toString()}");
    }
    return _res;
  }

  Future<bool> _connect(P2PAddrModel info) async {
    int _retryCount = 0;
    bool _connected = false;
    await Future.doWhile(() async {
      _retryCount++;
      print("connecting, retryCount is : $_retryCount");
      final id = await _sendingConnectRequest(info);
      final response = _gettingConnectResponse(id);
      //retry
      if (response == null) {
        return true;
      }
      _connected = (response.error == null);
      final retry = (!_connected && _retryCount < RETRY_NUMBER);
      print("connecting result is : connect:$_connected : retry:$_retryCount");
      return retry;
    });

    return _connected;
  }

  Future sendSDP(String sdp, String remoteCoreId, String? remotePeerId) async {
    final localCoreId = await accountInfo.getCoreId();
    if (localCoreId == null) throw 'Core id is null!!';

    String hexSDP = sdp.getHex();

    var connected = false;
    if (remotePeerId != null) {
      connected = await _connect(
          P2PAddrModel(id: remotePeerId, addrs: p2pState.address.value));
    }

    final _loginModel = P2PLoginBodyModel(
        info: connected
            ? P2PTransferModel(
                localCoreID: localCoreId,
                remotePeerID: remotePeerId,
                remoteCoreID: remoteCoreId)
            : P2PTransferModel(
                localCoreID: localCoreId, remoteCoreID: remoteCoreId),
        payload: P2PLoginPayloadModel(session: hexSDP));
    _sendingLoginRequest(_loginModel);
  }
}
const int RETRY_DELAY = 100;
const int RETRY_NUMBER = 4;

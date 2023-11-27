import 'dart:async';
import 'dart:convert';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';
import 'package:heyo/app/routes/app_pages.dart';

class P2PNodeResponseStream {
  P2PNodeResponseStream(
      {required this.p2pState,
      required this.libP2PStorageProvider,
      required this.accountRepository});

  StreamSubscription<P2PReqResNodeModel?>? _nodeResponseSubscription;
  bool advertiseRequested = false;
  final P2PState p2pState;
  LibP2PStorageProvider libP2PStorageProvider;
  /// temporarily added here since there is nothing to determine this class is in
  /// data or domain layer
  AccountRepository accountRepository;

  void setUp() {
    _setUpResponseStream();
  }

  void reset() {
    advertiseRequested = false;
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
    // 1. prints the event info
    // 2. check for advertised and if so send a advertise response

    p2pState.status[event.id]?.value = (event.error == null);

    print(
      '_onNewResponseEvent ${event.name} : ${event.id} : ',
    );

    p2pState.responses.add(event);
    print("_onNewResponseEvent : eventId is: ${event.id.toString()}");
    print("_onNewResponseEvent : eventName is: ${event.name.toString()}");
    print("_onNewResponseEvent : body is: ${event.body.toString()}");
    print("_onNewResponseEvent : error is: ${event.error.toString()}");

    if (event.name == P2PReqResNodeNames.connect &&
        event.error == null &&
        !advertiseRequested) {
      advertiseRequested = true;

      final info = P2PReqResNodeModel(name: P2PReqResNodeNames.advertise);
      Future.delayed(const Duration(seconds: 1),() async{
      final id = await FlutterP2pCommunicator.sendRequest(info: info);
      });
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
      p2pState.advertise.value = true;
    } else if (event.name == P2PReqResNodeNames.addDelegatedCoreID &&
        event.error != null &&
        event.error!.contains('invalid')) {
      await accountRepository.logout();
      await Get.offAllNamed(AppPages.INITIAL);
    } else if (event.name == P2PReqResNodeNames.addrs && event.error == null) {
      p2pState.address.value = (event.body!["addrs"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }
    if (event.name == P2PReqResNodeNames.peerID && event.error == null) {
      p2pState.peerId.value = event.body!["peerID"].toString();
      final coreId = (await libP2PStorageProvider.getLocalCoreId())!;
      final peerId = p2pState.peerId.value;
      final addressId = jsonEncode(p2pState.address.value);
      print(
          "PEER ID RECEIVED ${coreId + SHARED_ADDR_SEPARATOR + peerId + SHARED_ADDR_SEPARATOR + addressId}");
    }
  }
}

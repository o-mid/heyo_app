import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
import '../../chats/data/models/chat_model.dart';
import '../../messages/connection/wifi_direct_connection_repo.dart';
import '../../messages/connection/wifi_direct_connection_controller.dart';
import '../../../../modules/features/contact/data/local_contact_repo.dart';

class WifiDirectController extends GetxController {
  WifiDirectController(
      {required AccountRepository accountInfoRepo,
      // required this.wifiDirectConnectionController,
      required this.contactRepository})
      : _accountInfoRepo = accountInfoRepo;

  final AccountRepository _accountInfoRepo;

  // final AccountInfo accountInfo;
  final LocalContactRepo contactRepository;

  HeyoWifiDirect? _heyoWifiDirect;
  bool isLocationPermissionGranted = false;
  final wifiDirectEnabled = false.obs;
  RxList<UserModel> availableDirectUsers = <UserModel>[].obs;
  // _heyoWifiDirect = wifiDirectConnectionController.wifiDirectWrapper!.pluginInstance;

  final coreId = "".obs;
  final visibleName = "".obs;

  late StreamSubscription _eventListener;
  late StreamSubscription _messageListener;

  // TODO create and handle listeners for streams of consumerEventSource and tcpMessage controllers

  @override
  Future<void> onInit() async {
    await _setCoreId();
    _heyoWifiDirect = WifiDirectWrapper.pluginInstance;
    _heyoWifiDirect ?? _initializePlugin();

    //TODO remove debug print
    print(
        "WifiDirectController: onInit(). Is _heyoWifiDirect.consumerEventSource.hasListener -> ${_heyoWifiDirect?.consumerEventSource.hasListener}");

    _eventListener = _heyoWifiDirect!.consumerEventSource.stream
        .listen((event) => eventHandler(event));
    _messageListener = _heyoWifiDirect!.tcpMessage.stream
        .listen((message) => _messageHandler(message));
    await wifiDirectOn();
    wifiDirectEnabled.value = await _heyoWifiDirect!.isWifiDirectEnabled();

    //TODO remove debug print
    print(
        "WifiDirectController: onInit() wifiDirectEnabled value $wifiDirectEnabled");

    super.onInit();
  }

  @override
  void onReady() {
    //to check location permission uncomment the following line
    checkLocationPermission();

    // to add mock users to peers list uncomment the following line
    // _addMockUsers();
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    await _eventListener.cancel();
    await _messageListener.cancel();
    await wifiDirectOff();

    super.onClose();
  }

  void _initializePlugin() async {
    if (coreId.value != "") {
      // TODO inspect/define user name for service advertising broadcast

      visibleName.value = "name";

      _heyoWifiDirect = HeyoWifiDirect(
          coreID: coreId.value, name: 'name', debugOutputEnable: true);
      WifiDirectWrapper.pluginInstance = _heyoWifiDirect;
      // await _heyoWifiDirect!.wifiDirectOn();
      /*  wifiDirectConnectionController.wifiDirectWrapper!.pluginInstance = _heyoWifiDirect;
      Get.put(wifiDirectConnectionController);*/
    }
  }

  eventHandler(WifiDirectEvent event) {
    print(
        'WifiDirectController: WifiDirect event: ${event.type}, ${event.dateTime}');

    switch (event.type) {
      // Refresh information about wifi-direct available peers
      case EventType.peerListRefresh:
        // PeerList peerList = signaling.wifiDirectPlugin.peerList;
        Map<String, Peer> peersAvailable = (event.message as PeerList).peers;
        print(
            'WifiDirectController: peerListRefresh: ${peersAvailable.toString()}');
        _peersToUsers(peersAvailable);
        break;

      case EventType.linkedPeer:
        // incomingConnection = true.obs;
        // connectedPeer = event.message as Peer;
        /*(wifiDirectConnectionController.connectionRepo as WiFiDirectConnectionRepoImpl)
            .handleWifiDirectEvents(event);*/

        print(
            'WifiDirectController: linked to ${(event.message as Peer).multiAddress}');
        break;

      case EventType.groupStopped:
        // incomingConnection = false.obs;
        // outgoingConnection = false.obs;
        // connectedPeer = null;
        /* (wifiDirectConnectionController.connectionRepo as WiFiDirectConnectionRepoImpl)
            .handleWifiDirectEvents(event);*/

        print('WifiDirectController: Wifi-direct group stopped');
        break;

      default:
        break;
    }
  }

  _messageHandler(HeyoWifiDirectMessage message) {
    /*  (wifiDirectConnectionController.connectionRepo as WiFiDirectConnectionRepoImpl)
        .wifiDirectmessageHandler(message);*/
  }

  Future<bool> connectPeer(String coreId, {bool encrypt = true}) async {
    final result = await _heyoWifiDirect!.connectPeer(coreId);
    if (result.type == EventType.linkedPeer) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> wifiDirectOn() async {
    if (_heyoWifiDirect != null) {
      return await _heyoWifiDirect!.wifiDirectOn();
    }
    return false;
  }

  Future<bool> wifiDirectOff() async {
    if (_heyoWifiDirect != null) {
      return await _heyoWifiDirect!.wifiDirectOff();
    }
    return false;
  }

  Future<void> _setCoreId() async {
    coreId.value = (await _accountInfoRepo.getUserAddress()) ?? "";

    //coreId.value = (await accountInfo.getCorePassCoreId()) ?? "";
  }

  // this will show a custom UI permission dialog at first and then the default permission dialog for location permission
  Future<void> checkLocationPermission() async {
    isLocationPermissionGranted = await PermissionFlow(
      permission: Permission.location,
      subtitle: LocaleKeys.Permissions_wifiDirectLocation.tr,
      indicatorIcon: Assets.svg.locationOutlined.svg(
        width: 28.w,
        height: 28.w,
      ),
    ).start();
  }

  void switchWifiDirect() async {
    if (wifiDirectEnabled.value) {
      await wifiDirectOff();
    } else {
      await wifiDirectOn();
    }
    wifiDirectEnabled.value = await _heyoWifiDirect!.isWifiDirectEnabled();
  }

  _peersToUsers(Map<String, Peer> peersAvailable) {
    availableDirectUsers.value = [];
    peersAvailable.values.forEach((peer) {
      final user = UserModel(
        name: peer.name,
        walletAddress: peer.coreID,
        coreId: peer.coreID,
      );
      availableDirectUsers.add(user);
    });
  }

  // this will add one UserModel to peers list with the duration provided for testing purposes
  // _addMockUsers({Duration duration = const Duration(seconds: 3)}) async {
  //   var mockUsers = [
  //     UserModel(
  //       name: "Boiled Dealmaker",
  //       iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
  //       isVerified: true,
  //       walletAddress: "CB11${List.generate(11, (index) => index).join()}14AB",
  //       coreId: "CB11${List.generate(11, (index) => index).join()}14AB",
  //     ),
  //     UserModel(
  //       name: "Crapps Wallbanger",
  //       iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
  //       walletAddress: "CB11${List.generate(11, (index) => index).join()}49BB",
  //       coreId: "CB11${List.generate(11, (index) => index).join()}49BB",
  //     ),
  //     UserModel(
  //       name: "Fancy Potato",
  //       iconUrl: "https://avatars.githubusercontent.com/u/6644146?v=4",
  //       walletAddress: "CB11${List.generate(11, (index) => index).join()}11FE",
  //       coreId: "CB11${List.generate(11, (index) => index).join()}11FE",
  //     ),
  //     UserModel(
  //       name: "Ockerito Fazola",
  //       isVerified: true,
  //       iconUrl: "https://avatars.githubusercontent.com/u/7844146?v=4",
  //       walletAddress: "CB11${List.generate(11, (index) => index).join()}5A5D",
  //       coreId: "CB11${List.generate(11, (index) => index).join()}5A5D",
  //     ),
  //     UserModel(
  //       name: "Unchained Banana",
  //       iconUrl: "https://avatars.githubusercontent.com/u/7847725?v=4",
  //       walletAddress: "CB11${List.generate(11, (index) => index).join()}44AC",
  //       coreId: "CB11${List.generate(11, (index) => index).join()}44AC",
  //     ),
  //   ];
  //   for (int i = 0; i < mockUsers.length; i++) {
  //     await Future.delayed(duration, () {
  //       availableDirectUsers.add(mockUsers[i]);
  //     });
  //   }
  // }
}

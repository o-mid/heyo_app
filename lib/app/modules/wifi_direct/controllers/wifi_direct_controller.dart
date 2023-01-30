import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
import '../../chats/data/models/chat_model.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../p2p_node/data/account/account_info.dart';

class WifiDirectController extends GetxController {
  final AccountInfo accountInfo;
  HeyoWifiDirect? _heyoWifiDirect;
  bool isLocationPermissionGranted = false;
  final wifiDirectEnabled = false.obs;
  RxList<UserModel> availableDirectUsers = <UserModel>[].obs;

  WifiDirectController({required this.accountInfo, required HeyoWifiDirect? heyoWifiDirect})
      : _heyoWifiDirect = heyoWifiDirect;
  final coreId = "".obs;
  final visibleName = "".obs;

  late StreamSubscription _eventListener;
  late StreamSubscription _messageListener;

  // TODO create and handle listeners for streams of consumerEventSource and tcpMessage controllers

  @override
  Future<void> onInit() async {
    await _setCoreId();
    _heyoWifiDirect ?? _initializePlugin();
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
  void onClose() {
    super.onClose();
    _eventListener.cancel();
    _messageListener.cancel();
  }

  void _initializePlugin() async {
    if (coreId.value != "") {
      // TODO inspect/define user name for service advertising broadcast

      visibleName.value = "name";

      _heyoWifiDirect = HeyoWifiDirect(coreID: coreId.value, name: 'name');
      await _heyoWifiDirect!.wifiDirectOn();
      _eventListener =
          _heyoWifiDirect!.consumerEventSource.stream.listen((event) => _eventHandler(event));
      _messageListener =
          _heyoWifiDirect!.tcpMessage.stream.listen((message) => _messageHandler(message));
      wifiDirectEnabled.value = await _heyoWifiDirect!.isWifiDirectEnabled();
    }
  }

  _eventHandler(WifiDirectEvent event) {
    print('WifiDirectController: WifiDirect event: ${event.type}, ${event.dateTime}');

    switch (event.type) {
      // Refresh information about wifi-direct available peers
      case EventType.peerListRefresh:

        // PeerList peerList = signaling.wifiDirectPlugin.peerList;
        Map<String, Peer> peersAvailable = (event.message as PeerList).peers;
        print('WifiDirectController: peerListRefresh: ${peersAvailable.toString()}');
        _peersToUsers(peersAvailable);
        break;

      case EventType.linkedPeer:
        // incomingConnection = true.obs;
        // connectedPeer = event.message as Peer;
        print('WifiDirectController: linked to ${(event.message as Peer).multiaddr}');
        break;

      case EventType.groupStopped:
        // incomingConnection = false.obs;
        // outgoingConnection = false.obs;
        // connectedPeer = null;
        print('WifiDirectController: Wifi-direct group stopped');
        break;

      default:
        break;
    }
  }

  _messageHandler(HeyoWifiDirectMessage message) {
    print('WifiDirectController: WifiDirect message: ${message.body}, from ${message.senderId}');
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
    coreId.value = (await accountInfo.getCoreId()) ?? "";
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
          icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
          walletAddress: peer.coreID,
          chatModel: ChatModel(
            name: peer.name,
            icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
            id: peer.coreID,
            lastMessage: "",
            timestamp: DateTime.now(),
          ));
      availableDirectUsers.add(user);
    });
  }

  // this will add one UserModel to peers list with the duration provided for testing purposes
  _addMockUsers({Duration duration = const Duration(seconds: 3)}) async {
    var mockUsers = [
      UserModel(
        name: "Boiled Dealmaker",
        icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
        isVerified: true,
        walletAddress: "CB11${List.generate(11, (index) => index).join()}14AB",
        chatModel: ChatModel(
          name: "Boiled Dealmaker",
          icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
          isVerified: true,
          id: "CB11${List.generate(11, (index) => index).join()}14AB",
          lastMessage: "",
          timestamp: DateTime.now(),
        ),
      ),
      UserModel(
        name: "Crapps Wallbanger",
        icon: "https://avatars.githubusercontent.com/u/2345136?v=4",
        walletAddress: "CB11${List.generate(11, (index) => index).join()}49BB",
        chatModel: ChatModel(
          name: "Crapps Wallbanger",
          icon: "https://avatars.githubusercontent.com/u/2345136?v=4",
          id: "CB11${List.generate(11, (index) => index).join()}49BB",
          lastMessage: "",
          timestamp: DateTime.now(),
        ),
      ),
      UserModel(
          name: "Fancy Potato",
          icon: "https://avatars.githubusercontent.com/u/6644146?v=4",
          walletAddress: "CB11${List.generate(11, (index) => index).join()}11FE",
          chatModel: ChatModel(
            name: "Fancy Potato",
            icon: "https://avatars.githubusercontent.com/u/6644146?v=4",
            id: "CB11${List.generate(11, (index) => index).join()}11FE",
            lastMessage: "",
            timestamp: DateTime.now(),
          )),
      UserModel(
          name: "Ockerito Fazola",
          isVerified: true,
          icon: "https://avatars.githubusercontent.com/u/7844146?v=4",
          walletAddress: "CB11${List.generate(11, (index) => index).join()}5A5D",
          chatModel: ChatModel(
            name: "Ockerito Fazola",
            icon: "https://avatars.githubusercontent.com/u/7844146?v=4",
            id: "CB11${List.generate(11, (index) => index).join()}5A5D",
            isVerified: true,
            lastMessage: "",
            timestamp: DateTime.now(),
          )),
      UserModel(
          name: "Unchained Banana",
          icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
          walletAddress: "CB11${List.generate(11, (index) => index).join()}44AC",
          chatModel: ChatModel(
            name: "Unchained Banana",
            icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
            id: "CB11${List.generate(11, (index) => index).join()}44AC",
            lastMessage: "",
            timestamp: DateTime.now(),
          )),
    ];
    for (int i = 0; i < mockUsers.length; i++) {
      await Future.delayed(duration, () {
        availableDirectUsers.add(mockUsers[i]);
      });
    }
  }
}

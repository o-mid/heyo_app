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
  HeyoWifiDirect? heyoWifiDirect;
  bool isLocationPermissionGranted = false;
  final wifiDirectEnabled = false.obs;
  RxList<UserModel> availablePeers = <UserModel>[].obs;

  WifiDirectController({required this.accountInfo, required this.heyoWifiDirect});
  final coreId = "".obs;

  // TODO create and handle listeners for streams of consumerEventSource and tcpMessage controllers

  @override
  Future<void> onInit() async {
    await setCoreid();
    heyoWifiDirect ?? initializePlugin();
    super.onInit();
  }

  @override
  void onReady() {
    //to check location permission uncomment the following line
    //checkLocationPermission();

    // to add mock users to peers list uncomment the following line
    //_addMockUsers();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initializePlugin() {
    if (coreId.value != "") {
      // TODO inspect/define user name for service advertising broadcast
      heyoWifiDirect = HeyoWifiDirect(coreID: coreId.value, name: 'name');
    }
  }

  Future<bool> wifiDirectOn() async {
    if (heyoWifiDirect != null) {
      return await heyoWifiDirect!.wifiDirectOn();
    }
    return false;
  }

  Future<bool> wifiDirectOff() async {
    if (heyoWifiDirect != null) {
      return await heyoWifiDirect!.wifiDirectOff();
    }
    return false;
  }

  Future<void> setCoreid() async {
    coreId.value = (await accountInfo.getCoreId()) ?? "";
  }

  // this will show a custum UI permission dialog at first and then the default permission dialog for location permission
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
    wifiDirectEnabled.value = (await heyoWifiDirect?.isWifiDirectEnabled())!;
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
        availablePeers.add(mockUsers[i]);
      });
    }
  }
}

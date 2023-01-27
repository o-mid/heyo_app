import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
import '../../p2p_node/data/account/account_info.dart';

class WifiDirectController extends GetxController {
  final AccountInfo accountInfo;
  HeyoWifiDirect? heyoWifiDirect;
  bool isLocationPermissionGranted = false;
  final wifiDirectEnabled = false.obs;
  RxList<Peer> availablePeers = <Peer>[].obs;

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
}

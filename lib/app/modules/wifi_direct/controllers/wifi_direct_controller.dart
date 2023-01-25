import 'package:get/get.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../p2p_node/data/account/account_info.dart';

class WifiDirectController extends GetxController {
  final AccountInfo accountInfo;
  HeyoWifiDirect? heyoWifiDirect;

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
}

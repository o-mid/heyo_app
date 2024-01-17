import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/wifi_direct/widgets/appbar/wifi_direct_app_bar_widget.dart';
import 'package:heyo/app/modules/wifi_direct_connect/controllers/wifi_direct_connect_controller.dart';

class WifiDirectConnectView extends GetView<WifiDirectConnectController> {
  const WifiDirectConnectView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.startConnection();
    return Scaffold(
      appBar: wifiDirectAppBarWidget(),
      body: Center(
        child: Column(
          children: [
            Text(
              controller.user.name,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              controller.user.coreId,
              style: const TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Obx(() {
              return Text(
                controller.connectionStatus.value.toString(),
                style: const TextStyle(fontSize: 14),
              );
            })
          ],
        ),
      ),
    );
  }
}

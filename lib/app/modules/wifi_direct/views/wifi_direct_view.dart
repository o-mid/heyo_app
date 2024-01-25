import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/screen-utils/buttons/custom_button.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';

import '../controllers/wifi_direct_controller.dart';
import '../widgets/appbar/wifi_direct_app_bar_widget.dart';
import '../widgets/body/peers_list_widget.dart';

class WifiDirectView extends GetView<WifiDirectController> {
  const WifiDirectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: wifiDirectAppBarWidget(),
        body: Padding(
          padding: CustomSizes.mainContentPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             // const PeersListWidget(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Wifi Direct is ${controller.wifiDirectEnabled.value ? "ON" : "OFF"} "),
                      controller.wifiDirectEnabled.value
                          ? const Icon(Icons.wifi, color: COLORS.kGreenMainColor)
                          : const Icon(Icons.wifi_off, color: COLORS.kStatesErrorColor),
                    ],
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                  CustomButton.primarySmall(
                    onTap: () => controller.switchWifiDirect(),
                    title: "Switch wifi Direct",
                  ),
                  CustomSizes.largeSizedBoxHeight,
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

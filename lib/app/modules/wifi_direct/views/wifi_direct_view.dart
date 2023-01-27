import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/fonts.dart';
import '../../shared/utils/screen-utils/buttons/custom_button.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../controllers/wifi_direct_controller.dart';

class WifiDirectView extends GetView<WifiDirectController> {
  const WifiDirectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: COLORS.kGreenMainColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            LocaleKeys.newChat_wifiDirect_wifiDirectAppbar.tr,
            style: const TextStyle(
              fontWeight: FONTS.Bold,
              fontFamily: FONTS.interFamily,
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: CustomSizes.mainContentPadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.availablePeers.isEmpty
                    ? EmptyUsersBody(
                        infoText: LocaleKeys.newChat_wifiDirect_emptyPeersTitle.tr,
                      )
                    : const SizedBox(),
                CustomSizes.largeSizedBoxHeight,
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
              ],
            ),
          ),
        ),
      );
    });
  }
}

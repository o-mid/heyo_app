import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import '../../../shared/controllers/user_preview_controller.dart';

import '../../../../../generated/locales.g.dart';
import '../../../new_chat/widgets/user_widget.dart';
import '../../../shared/utils/constants/colors.dart';
import '../../../shared/utils/constants/textStyles.dart';
import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../controllers/wifi_direct_controller.dart';

class PeersListWidget extends GetView<WifiDirectController> {
  const PeersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(children: [
        CustomSizes.largeSizedBoxHeight,
        if (controller.availableDirectUsers.isEmpty)
          Center(
            child: EmptyUsersBody(
              infoText: LocaleKeys.wifiDirect_emptyPeersTitle.tr,
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wifiDirect_availablePeers.tr,
                style: TEXTSTYLES.kLinkSmall.copyWith(color: COLORS.kTextSoftBlueColor),
              ),
              CustomSizes.mediumSizedBoxHeight,
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.availableDirectUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Get.find<UserPreviewController>().openUserPreview(
                            coreId: controller.availableDirectUsers[index].coreId,
                            isWifiDirect: true,
                          );
                        },
                        child: UserWidget(
                          coreId: controller.availableDirectUsers[index].coreId,
                          name: controller.availableDirectUsers[index].name,
                          isOnline: controller.availableDirectUsers[index].isOnline,
                          showAudioCallButton: true,
                          showVideoCallButton: true,
                          walletAddress: controller.availableDirectUsers[index].coreId,
                        ),
                      ),
                      CustomSizes.mediumSizedBoxHeight,
                    ],
                  );
                },
              ),
            ],
          ),
        CustomSizes.largeSizedBoxHeight,
      ]);
    });
  }
}

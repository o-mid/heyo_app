import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';

import '../../../../../generated/locales.g.dart';
import '../../../new_chat/widgets/user_preview_bottom_sheet.dart';
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
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        CustomSizes.largeSizedBoxHeight,
        controller.availableDirectUsers.isEmpty
            ? Center(
                child: EmptyUsersBody(
                  infoText: LocaleKeys.wifiDirect_emptyPeersTitle.tr,
                ),
              )
            : Column(
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
                              openUserPreviewBottomSheet(
                                controller.availableDirectUsers[index],
                                isWifiDirect: true,
                                contactRepository: controller.contactRepository,
                              );
                            },
                            child: UserWidget(
                              user: controller.availableDirectUsers[index],
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

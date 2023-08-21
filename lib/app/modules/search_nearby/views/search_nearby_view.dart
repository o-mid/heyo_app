import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';

import '../../../../generated/locales.g.dart';
import '../../../routes/app_pages.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/widgets/empty_contacts_body.dart';
import '../controllers/search_nearby_controller.dart';

class SearchNearbyView extends GetView<SearchNearbyController> {
  const SearchNearbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(title: LocaleKeys.newChat_slider_nearbyUsers.tr),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyContactsBody(
            infoText: LocaleKeys.newChat_emptyStateTitleNearbyUsers.tr,
            buttonText: "Share Info",
            onInvite: () => Get.toNamed(Routes.SHREABLE_QR),
          ),
          const SizedBox(height: 30),
        ],
      )),
    );
  }
}

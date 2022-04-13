import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/account/views/account_view.dart';
import 'package:heyo/app/modules/calls/views/calls_view.dart';
import 'package:heyo/app/modules/chats/views/chats_view.dart';
import 'package:heyo/app/modules/search_nearby/views/search_nearby_view.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/widgets/bottom_navigation_bar.dart';
import 'package:heyo/app/modules/wallet/views/wallet_view.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _pageNavigation = [
    ChatsView(),
    CallsView(),
    WalletView(),
    SearchNearbyView(),
    AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: COLORS.kGreenMainColor,
          title: Text(
            LocaleKeys.HomePage_title.tr,
            style: TextStyle(
              fontWeight: FONTS.Bold,
              fontFamily: FONTS.interFamily,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: _pageNavigation[controller.tabIndex.value],
        bottomNavigationBar: BottomNavigationBarCustom(
          show: true,
          currentIndex: controller.tabIndex.value,
          onTap: (int currentIndex) {
            controller.changeTabIndex(currentIndex);
          },
        ),
      ),
    );
  }
}

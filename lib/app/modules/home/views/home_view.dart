import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/account/views/account_view.dart';
import 'package:heyo/app/modules/calls/views/calls_view.dart';
import 'package:heyo/app/modules/chats/views/chats_view.dart';
import 'package:heyo/app/modules/home/widgets/new_chat_bottom_sheet.dart';
import 'package:heyo/app/modules/search_nearby/views/search_nearby_view.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_navigation_bar.dart';
import 'package:heyo/app/modules/wallet/views/wallet_view.dart';
import 'package:heyo/generated/assets.gen.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _pageNavigation = [
    const ChatsView(),
    const CallsView(),
    WalletView(),
    SearchNearbyView(),
    AccountView(),
  ];

  final _pageFab = [
    FloatingActionButton(
      onPressed: openNewChatBottomSheet,
      backgroundColor: COLORS.kGreenMainColor,
      child: Assets.svg.newChat.svg(),
    ),
    const FloatingActionButton(
      onPressed: null,
      backgroundColor: COLORS.kGreenMainColor,
      child: Icon(Icons.add_circle_outline),
    ),
    null,
    null,
    null,
  ];

  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pageNavigation[controller.tabIndex.value],
        floatingActionButton: _pageFab[controller.tabIndex.value],
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

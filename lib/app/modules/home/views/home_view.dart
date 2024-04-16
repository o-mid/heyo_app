import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/account/views/account_view.dart';
import 'package:heyo/modules/features/chats/presentation/pages/chat_history_page.dart';
import 'package:heyo/app/modules/home/widgets/new_chat_bottom_sheet.dart';
import 'package:heyo/app/modules/search_nearby/views/search_nearby_view.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_navigation_bar.dart';
import 'package:heyo/app/modules/wallet/views/wallet_view.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/modules/features/call_history/presentation/pages/call_history_page.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _pageNavigation = [
    const ChatHistoryPage(),
    const CallHistoryPage(),
    WalletView(),
    const SearchNearbyView(),
    const AccountView(),
  ];

  final _pageFab = [
    FloatingActionButton(
      onPressed: openNewChatBottomSheet,
      backgroundColor: COLORS.kGreenMainColor,
      child: Assets.svg.newChat.svg(),
    ),
    FloatingActionButton(
      onPressed: () {
        Get.toNamed(Routes.NEW_CALL);
      },
      backgroundColor: COLORS.kGreenMainColor,
      child: const Icon(Icons.add_circle_outline),
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

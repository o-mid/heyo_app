import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/account/views/account_view.dart';
import 'package:heyo/app/modules/calls/views/calls_view.dart';
import 'package:heyo/app/modules/chats/views/chats_view.dart';
import 'package:heyo/app/modules/search_nearby/views/search_nearby_view.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/bottom_navigation_bar.dart';
import 'package:heyo/app/modules/wallet/views/wallet_view.dart';
import 'package:heyo/generated/assets.gen.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              _bottomSheetFAB,
              backgroundColor: COLORS.kWhiteColor,
              isDismissible: true,
              persistent: true,
              enableDrag: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
            );
          },
          backgroundColor: COLORS.kGreenMainColor,
          child: Assets.svg.newChat.svg(),
        ),
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

Widget _bottomSheetFAB = Container(
  padding: CustomSizes.mainContentPadding,
  child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSizes.smallSizedBoxHeight,
        TextButton(
            //Todo: Start new chat onPressed
            onPressed: () {},
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: COLORS.kBrightBlueColor,
                    ),
                    child: Assets.svg.newChatIcon.svg(width: 20, height: 20),
                  ),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.HomePage_bottomSheet_newChat.tr,
                      style: TEXTSTYLES.kBodyBasic.copyWith(
                        color: COLORS.kDarkBlueColor,
                      ),
                    ))
              ],
            )),
        TextButton(
            //Todo: Start new group onPressed
            onPressed: () {},
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: COLORS.kBrightBlueColor,
                    ),
                    child: Assets.svg.newGroupIcon.svg(width: 20, height: 20),
                  ),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.HomePage_bottomSheet_newGroup.tr,
                      style: TEXTSTYLES.kBodyBasic.copyWith(
                        color: COLORS.kDarkBlueColor,
                      ),
                    ))
              ],
            )),
        TextButton(
            //Todo: invite onPressed
            onPressed: () {},
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: COLORS.kBrightBlueColor,
                    ),
                    child: Assets.svg.inviteIcon.svg(width: 20, height: 20),
                  ),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.HomePage_bottomSheet_invite.tr,
                      style: TEXTSTYLES.kBodyBasic.copyWith(
                        color: COLORS.kDarkBlueColor,
                      ),
                    ))
              ],
            )),
      ]),
);

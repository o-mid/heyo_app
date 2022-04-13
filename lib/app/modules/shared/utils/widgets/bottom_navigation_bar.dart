import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/widgets/notification_count_badge.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

class BottomNavigationBarCustom extends StatelessWidget {
  final int currentIndex;
  final Function onTap;
  final bool show;
  final int duration;

  BottomNavigationBarCustom(
      {required this.currentIndex, required this.onTap, this.show = true, this.duration = 250});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        onTap: (index) {
          print(index);
          onTap(index);
        },
        currentIndex: currentIndex,
        backgroundColor: COLORS.kWhiteColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TEXTSTYLES.kBodyTag.copyWith(fontWeight: FONTS.Bold),
        unselectedLabelStyle: TEXTSTYLES.kBodyTag.copyWith(fontWeight: FONTS.Bold),
        items: <BottomNavigationBarItem>[
          _buildNavItem(Assets.svg.chat, LocaleKeys.HomePage_navbarItems_chats.tr),
          _buildNavItem(Assets.svg.call, LocaleKeys.HomePage_navbarItems_calls.tr),
          _buildNavItem(Assets.svg.wallet, LocaleKeys.HomePage_navbarItems_wallet.tr),
          _buildNavItem(Assets.svg.searchNearby, LocaleKeys.HomePage_navbarItems_search.tr),
          _buildNavItem(Assets.svg.account, LocaleKeys.HomePage_navbarItems_account.tr),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(SvgGenImage icon, String label) {
    return BottomNavigationBarItem(
      activeIcon: _buildIconWithNotificationCounter(icon.svg(color: COLORS.kGreenMainColor), 0),
      icon: _buildIconWithNotificationCounter(icon.svg(), 0),
      label: label,
    );
  }

  Widget _buildIconWithNotificationCounter(Widget icon, int count) {
    return Container(
      width: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, top: 6),
            child: icon,
          ),
          if (count > 0)
            Positioned(
              top: 0,
              right: 0,
              child: NotificationCountBadge(
                count: count,
                backgroundColor: COLORS.kStatesErrorColor,
              ),
            ),
        ],
      ),
    );
  }
}

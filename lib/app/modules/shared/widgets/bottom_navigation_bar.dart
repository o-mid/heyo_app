import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/notification_count_badge.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

class BottomNavigationBarCustom extends StatelessWidget {
  final int currentIndex;
  final Function onTap;
  final bool show;
  final int duration;

  const BottomNavigationBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.show = true,
    this.duration = 250,
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1,
            ),
          ],
          color: COLORS.kWhiteColor,
        ),
        child: SafeArea(
          child: SizedBox(
            height: 76,
            child: BottomNavigationBar(
              elevation: 0,
              onTap: (index) {
                print(index);
                onTap(index);
              },
              currentIndex: currentIndex,
              backgroundColor: COLORS.kWhiteColor,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: COLORS.kGreenMainColor,
              selectedLabelStyle: TEXTSTYLES.kBodyTag.copyWith(
                fontWeight: FONTS.Bold,
              ),
              unselectedLabelStyle: TEXTSTYLES.kBodyTag.copyWith(
                fontWeight: FONTS.Bold,
              ),
              items: <BottomNavigationBarItem>[
                _buildNavItem(
                  Assets.svg.chat,
                  Assets.svg.chatOutlined,
                  LocaleKeys.HomePage_navbarItems_chats.tr,
                ),
                _buildNavItem(
                  Assets.svg.callFilled,
                  Assets.svg.call,
                  LocaleKeys.HomePage_navbarItems_calls.tr,
                ),
                _buildNavItem(
                  Assets.svg.wallet,
                  Assets.svg.wallet,
                  LocaleKeys.HomePage_navbarItems_wallet.tr,
                ),
                _buildNavItem(
                  Assets.svg.searchNearbyFilled,
                  Assets.svg.searchNearby,
                  LocaleKeys.HomePage_navbarItems_search.tr,
                ),
                _buildNavItem(
                  Assets.svg.accountFilled,
                  Assets.svg.account,
                  LocaleKeys.HomePage_navbarItems_account.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    SvgGenImage activeIcon,
    SvgGenImage deActiveIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      activeIcon: _buildIconWithNotificationCounter(
        icon: activeIcon.svg(
          width: 20.w,
          height: 20.w,
          color: COLORS.kGreenMainColor,
        ),
        notificationCount: 0,
      ),
      icon: _buildIconWithNotificationCounter(
        icon: deActiveIcon.svg(
          width: 20.w,
          height: 20.w,
          color: COLORS.kMessageSelectionOption,
        ),
        notificationCount: 0,
      ),
      label: label,
    );
  }

  Widget _buildIconWithNotificationCounter({
    required Widget icon,
    required int notificationCount,
  }) {
    return SizedBox(
      width: 35.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, top: 6),
            child: icon,
          ),
          if (notificationCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: NotificationCountBadge(
                count: notificationCount,
                backgroundColor: COLORS.kStatesErrorColor,
              ),
            ),
        ],
      ),
    );
  }
}

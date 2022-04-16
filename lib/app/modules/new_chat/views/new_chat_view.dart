import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../shared/utils/constants/fonts.dart';
import '../controllers/new_chat_controller.dart';
import '../widgets/user_widget.dart';

class NewChatView extends GetView<NewChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _newchatAppbar(),
      backgroundColor: COLORS.kWhiteColor,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: COLORS.kTabbarBackgroundColor,
              child: _tabbarSlider(),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _contacts(),
                  _nearbyUsers(
                    controller: controller,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TabBar _tabbarSlider() {
    return TabBar(
      labelColor: COLORS.kGreenMainColor,
      labelStyle: TEXTSTYLES.kLinkBig,
      automaticIndicatorColorAdjustment: true,
      unselectedLabelColor: COLORS.kTextBlueColor,
      tabs: [
        Tab(
          text: LocaleKeys.newChat_slider_contacts.tr,
        ),
        Tab(
          text: LocaleKeys.newChat_slider_nearbyUsers.tr,
        ),
      ],
      indicatorColor: COLORS.kGreenMainColor,
    );
  }

  AppBar _newchatAppbar() {
    return AppBar(
      backgroundColor: COLORS.kGreenMainColor,
      elevation: 0,
      centerTitle: false,
      title: Text(
        LocaleKeys.newChat_newChatAppBar.tr,
        style: TextStyle(
          fontWeight: FONTS.Bold,
          fontFamily: FONTS.interFamily,
        ),
      ),
      actions: [
        IconButton(
          //Todo : filter onPressed
          onPressed: () {},
          icon: Assets.svg.filterIcon.svg(),
        ),
        IconButton(
          //Todo : Show more onPressed
          onPressed: () {},
          icon: Assets.svg.moreIcon.svg(),
        ),
      ],
      automaticallyImplyLeading: true,
    );
  }
}

class _nearbyUsers extends StatelessWidget {
  const _nearbyUsers({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewChatController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Obx(() {
        return ListView.builder(
          itemCount: controller.nearbyUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              // TODO: User onPressed
              onTap: () {},
              child: Padding(
                padding: CustomSizes.userListPadding,
                child: UserWidget(User: controller.nearbyUsers[index]),
              ),
            );
          },
        );
      }),
    );
  }
}

class _contacts extends StatelessWidget {
  const _contacts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Assets.png.newChatEmptyState.image(
          alignment: Alignment.center,
        )),
        CustomSizes.largeSizedBoxHeight,
        Text(
          LocaleKeys.newChat_emptyStateTitle.tr,
          style: TEXTSTYLES.kBodyBasic.copyWith(
            color: COLORS.kTextBlueColor,
          ),
          textAlign: TextAlign.center,
        ),
        CustomSizes.largeSizedBoxHeight,
        CustomButton.primarySmall(
          // TODO : Invite button onPressed
          onTap: () {},
          color: COLORS.kGreenLighterColor,
          title: LocaleKeys.newChat_buttons_invite.tr,
          style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
        )
      ],
    );
  }
}

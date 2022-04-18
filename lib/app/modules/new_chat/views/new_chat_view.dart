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
          onPressed: () => _openFiltersBottomSheet(),
          icon: Assets.svg.filterIcon.svg(),
        ),
      ],
      automaticallyImplyLeading: true,
    );
  }

  void _openFiltersBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: CustomSizes.mainContentPadding,
        child: Column(mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSizes.smallSizedBoxHeight,
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                      // Close the bottom sheet
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: COLORS.kDarkBlueColor,
                      ),
                      label: Text(
                        LocaleKeys.newChat_buttons_filter.tr,
                        style: TEXTSTYLES.kHeaderLarge
                            .copyWith(color: COLORS.kDarkBlueColor),
                      ))),
              Obx(() {
                return ListView.builder(
                  itemCount: controller.filters.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        title: Text(
                          controller.filters[index].title,
                          style: TEXTSTYLES.kLinkBig
                              .copyWith(color: COLORS.kDarkBlueColor),
                        ),
                        value: controller.filters[index].isActive.value,
                        onChanged: (Value) {
                          if (Value != null) {
                            controller.filters[index].isActive.value = Value;

                            controller.filters.refresh();

                            controller.nearbyUsers.refresh();
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        activeColor: COLORS.kGreenMainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        controlAffinity: ListTileControlAffinity.leading);
                  },
                );
              }),
            ]),
      ),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
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
    return Obx(() {
      return controller.nearbyUsers.length == 0
          ? _nearbyUsersEmptyState()
          // if nearby users is available then run this :
          : Padding(
              padding: const EdgeInsets.only(top: 36),
              child: ListView.builder(
                itemCount: controller.nearbyUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  // this will check if verified filter is applyed or not
                  if (controller.filters.first.isActive.value &&
                      // check if user is verified or not
                      controller.nearbyUsers[index].isVerified == false) {
                    return SizedBox();
                  } else {
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      // TODO: User onPressed
                      onTap: () {},
                      child: Padding(
                        padding: CustomSizes.userListPadding,
                        child: UserWidget(User: controller.nearbyUsers[index]),
                      ),
                    );
                  }
                },
              ),
            );
    });
  }
}

class _nearbyUsersEmptyState extends StatelessWidget {
  const _nearbyUsersEmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.png.sadEmoji.image(),
        CustomSizes.largeSizedBoxHeight,
        Text(
          LocaleKeys.newChat_emptyStateTitleNearbyUsers.tr,
          style: TEXTSTYLES.kBodyBasic.copyWith(
            color: COLORS.kTextBlueColor,
          ),
          textAlign: TextAlign.center,
        )
      ],
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
          LocaleKeys.newChat_emptyStateTitleContacts.tr,
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

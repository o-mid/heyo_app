import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/widgets/invite_BottomSheet.dart';
import 'package:heyo/app/modules/new_chat/widgets/qr_scan_view.dart';
import 'package:heyo/app/modules/new_chat/widgets/userPreview_BottomSheet.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
                  _contacts(
                    controller: controller,
                  ),
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
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
      controller.makeRefreshBtnVisible();
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        onRefresh: controller.onRefresh,
        header: MaterialClassicHeader(
          color: COLORS.kGreenMainColor,
          distance: 32,
          backgroundColor: COLORS.kGreenLighterColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.nearbyUsers.length == 0
                ? _nearbyUsersEmptyState()
                // if nearby users is available then run this :
                : Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: ListView.builder(
                      shrinkWrap: true,
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
                            onTap: () => openUserPreviewBottomSheet(
                              controller.nearbyUsers[index],
                            ),
                            child: Padding(
                              padding: CustomSizes.userListPadding,
                              child: UserWidget(
                                  User: controller.nearbyUsers[index]),
                            ),
                          );
                        }
                      },
                    ),
                  ),
            Column(
              children: [
                Visibility(
                  // will be visible after delayed
                  visible: controller.refreshBtnVisibility.value,
                  child: ScaleTransition(
                    scale: controller.animation,
                    child: TextButton.icon(
                      onPressed: () {
                        controller.refreshController.requestRefresh();
                      },
                      icon: Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        color: COLORS.kGreenMainColor,
                        size: 22,
                      ),
                      label: Text(
                        LocaleKeys.newChat_buttons_pullDownToRefresh.tr,
                        style: TEXTSTYLES.kButtonSmall.copyWith(
                            color: COLORS.kGreenMainColor, wordSpacing: 0.5),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: COLORS.kGreenLighterColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 22)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
              ],
            )
          ],
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
    required this.controller,
  }) : super(key: key);
  final NewChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            CustomSizes.largeSizedBoxHeight,
            Padding(
              padding: CustomSizes.mainContentPadding,
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) =>
                      controller.isTextInputFocused.value = focus,
                  child: CUSTOMTEXTFIELD(
                      labelText: LocaleKeys.newChat_usernameInput.tr,
                      rightWidget: IconButton(
                        icon: Icon(
                          Icons.qr_code_rounded,
                          color: COLORS.kDarkBlueColor,
                        ),
                        onPressed: () => {
                          Get.bottomSheet(
                              FractionallySizedBox(
                                heightFactor: 1,
                                child: QrScanView(
                                  title: LocaleKeys.newChat_newChatAppBar.tr,
                                  hasBackButton: true,
                                  onQRViewCreated: controller.handleScannedVal,
                                  subtitle: '',
                                ),
                              ),
                              isScrollControlled: true)
                        },
                      ),
                      onChanged: (String value) {
                        controller.searchUsers(value);
                      }),
                ),
              ),
            ),
            controller.isTextInputFocused.value == false
                ? _contactsBody(controller: controller)
                : _searchBody(controller: controller),
          ],
        ),
      );
    });
  }
}

class _searchBody extends StatelessWidget {
  const _searchBody({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          CustomSizes.smallSizedBoxHeight,
          Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          CustomSizes.largeSizedBoxHeight,
          Padding(
            padding: CustomSizes.mainContentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.newChat_searchResults.tr,
                  style: TEXTSTYLES.kLinkSmall,
                ),
                CustomSizes.mediumSizedBoxHeight,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchSuggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    var suggestedUser = controller.searchSuggestions[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      // TODO: User onPressed
                      onTap: () {
                        openUserPreviewBottomSheet(
                            controller.searchSuggestions[index]);
                      },
                      child: Padding(
                          padding: CustomSizes.userListPadding,
                          child: UserWidget(
                            User: suggestedUser,
                          )),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _contactsBody extends StatelessWidget {
  const _contactsBody({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewChatController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizes.largeSizedBoxHeight,
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
          onTap: () => openInviteBottomSheet(controller.profile),

          color: COLORS.kGreenLighterColor,
          title: LocaleKeys.newChat_buttons_invite.tr,
          style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
        ),
      ],
    );
  }
}

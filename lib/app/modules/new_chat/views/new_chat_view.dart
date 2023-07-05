import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scanner.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/contact_list_with_header.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../shared/utils/constants/fonts.dart';
import '../controllers/new_chat_controller.dart';
import '../widgets/app_bar_action_bottom_sheet.dart';

class NewChatView extends GetView<NewChatController> {
  const NewChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _newchatAppbar(),
      backgroundColor: COLORS.kWhiteColor,
      body: DefaultTabController(
        length: 2,
        child: _Contacts(
          controller: controller,
        ),
      ),
    );
  }

/*
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
*/

  AppBar _newchatAppbar() {
    return AppBar(
      backgroundColor: COLORS.kGreenMainColor,
      elevation: 0,
      centerTitle: false,
      title: Text(
        LocaleKeys.newChat_newChatAppBar.tr,
        style: const TextStyle(
          fontWeight: FONTS.Bold,
          fontFamily: FONTS.interFamily,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _openFiltersBottomSheet(),
          icon: Assets.svg.filterIcon.svg(),
        ),
        IconButton(
          onPressed: () => openAppBarActionBottomSheet(
            profileLink: controller.profileLink,
          ),
          icon: Assets.svg.dotColumn.svg(
            width: 5,
          ),
        ),
      ],
      automaticallyImplyLeading: true,
    );
  }

  void _openFiltersBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: CustomSizes.mainContentPadding,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSizes.smallSizedBoxHeight,
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  // Close the bottom sheet
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: COLORS.kDarkBlueColor,
                  ),
                  label: Text(
                    LocaleKeys.newChat_buttons_filter.tr,
                    style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
                  ),
                ),
              ),
              Obx(() {
                return ListView.builder(
                  itemCount: controller.filters.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        title: Text(
                          controller.filters[index].title,
                          style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}

/*
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
        header: const MaterialClassicHeader(
          color: COLORS.kGreenMainColor,
          distance: 32,
          backgroundColor: COLORS.kGreenLighterColor,
        ),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              controller.nearbyUsers.isEmpty
                  ? const _nearbyUsersEmptyState()
                  // if nearby users is available then run this :
                  : Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.nearbyUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          //this will grab the current user and
                          // extract the first character from its name
                          String _currentUsernamefirstchar = controller
                              .nearbyUsers[index].name.characters.first;
                          //this will grab the next user in the list if its not null and
                          // extract the first character from its name
                          String _nextUsernamefirstchar = controller.nearbyUsers
                                      .indexOf(controller.nearbyUsers.last) >
                                  index + 1
                              ? controller
                                  .nearbyUsers[index + 1].name.characters.first
                              : "";

                          // this will check if verified filter is applyed or not

                          if (controller.filters.first.isActive.value &&
                              // check if user is verified or not
                              controller.nearbyUsers[index].isVerified ==
                                  false) {
                            return const SizedBox();
                          } else if (controller.filters.last.isActive.value &&
                              // check if user is online or not
                              controller.nearbyUsers[index].isOnline == false) {
                            return const SizedBox();
                          } else {
                            return Padding(
                              padding: CustomSizes.userListPadding,
                              child: Column(
                                children: [
                                  // if first character of current user name Is(not) equal to
                                  // first character of next user name then add a header
                                  _currentUsernamefirstchar !=
                                          _nextUsernamefirstchar
                                      ? ListHeaderWidget(
                                          title: controller.nearbyUsers[index]
                                              .name.characters.first
                                              .toUpperCase())
                                      : const SizedBox(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () => openUserPreviewBottomSheet(
                                        controller.nearbyUsers[index]),
                                    child: UserWidget(
                                        User: controller.nearbyUsers[index]),
                                  ),
                                ],
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
                        icon: const Icon(
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
                            padding: const EdgeInsets.symmetric(
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
        ),
      );
    });
  }
}
*/

/*
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
*/

class _Contacts extends StatelessWidget {
  const _Contacts({
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
                  onFocusChange: (focus) => controller.isTextInputFocused.value = focus,
                  focusNode: controller.inputFocusNode,
                  child: CUSTOMTEXTFIELD(
                    textController: controller.inputController,
                    labelText: LocaleKeys.newChat_usernameInput.tr,
                    rightWidget: IconButton(
                      icon: const Icon(
                        Icons.qr_code_rounded,
                        color: COLORS.kDarkBlueColor,
                      ),
                      onPressed: () => {openQrScannerBottomSheet(controller.handleScannedValue)},
                    ),
                  ),
                ),
              ),
            ),
            controller.searchSuggestions.isEmpty
                ? EmptyUsersBody(
                    infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
                    buttonText: LocaleKeys.newChat_buttons_invite.tr,
                    onInvite: () => openInviteBottomSheet(
                      profileLink: controller.profileLink,
                    ),
                  )
                : _SearchInContactsBody(controller: controller),
          ],
        ),
      );
    });
  }
}

class _SearchInContactsBody extends StatelessWidget {
  const _SearchInContactsBody({
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
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          CustomSizes.largeSizedBoxHeight,
          Padding(
            padding: CustomSizes.mainContentPadding,
            child: ContactListWithHeader(
              contacts: controller.searchSuggestions,
              searchMode: controller.inputController.text.isNotEmpty,
            ),
          ),
        ],
      );
    });
  }
}

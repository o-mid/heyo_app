import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../contacts/widgets/removeContactsDialog.dart';
import '../../shared/data/models/add_contacts_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/constants/transitions_constant.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';

class UserPreview extends GetxController {
  UserModel user;
  final ContactRepository contactRepository;

  UserPreview({required this.user, required this.contactRepository});

  getUser() async {
    if (user.isContact == true) {
      final currentUser = await contactRepository.getContactById(user.coreId);
      if (currentUser != null) {
        user = currentUser;
        print("currentUser is contact with name ${currentUser.name}");
      } else {
        print("user is not contact ");
      }
    }
  }

  Future<void> openUserPreviewBottomSheet({bool isWifiDirect = false}) async {
    print("openUserPreviewBottomSheet");
    await getUser();
    Get.bottomSheet(
      enterBottomSheetDuration: TRANSITIONS.newChat_EnterBottomSheetDuration,
      exitBottomSheetDuration: TRANSITIONS.newChat_ExitBottomSheetDuration,
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSizes.largeSizedBoxHeight,
            CustomCircleAvatar(url: user.iconUrl, size: 64),
            CustomSizes.mediumSizedBoxHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
                ),
                CustomSizes.smallSizedBoxWidth,
                user.isVerified
                    ? Assets.svg.verifiedWithBluePadding
                        .svg(alignment: Alignment.center, height: 24.w, width: 24.w)
                    : const SizedBox(),
              ],
            ),
            CustomSizes.smallSizedBoxHeight,
            Text(
              user.walletAddress.shortenCoreId,
              style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
            ),
            CustomSizes.largeSizedBoxHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleIconButton(
                  onPressed: () {
                    if (user.coreId.isEmpty) {
                      return;
                    } else {
                      Get.back();

                      Get.toNamed(
                        Routes.MESSAGES,
                        arguments: MessagesViewArgumentsModel(
                            user: user.copyWith(
                              isOnline: true,
                              isVerified: true,
                              name: user.name.isEmpty
                                  ? "${user.walletAddress.characters.take(4).string}...${user.walletAddress.characters.takeLast(4).string}"
                                  : user.name,
                              coreId: user.walletAddress,
                            ),
                            connectionType: isWifiDirect
                                ? MessagingConnectionType.wifiDirect
                                : MessagingConnectionType.internet),
                      );
                    }
                  },
                  backgroundColor: COLORS.kBrightBlueColor,
                  icon: Assets.svg.chatOutlined.svg(
                    color: COLORS.kDarkBlueColor,
                  ),
                ),
                CustomSizes.largeSizedBoxWidth,
                CircleIconButton(
                  onPressed: () {
                    Get.back();

                    if (!isWifiDirect) {
                      Get.toNamed(
                        Routes.CALL,
                        arguments: CallViewArgumentsModel(
                            session: null,
                            callId: null,
                            user: user,
                            enableVideo: false,
                            isAudioCall: true),
                      );
                    } else {
                      Get.snackbar("Wifi Direct", "Calling over wifi direct are not supported yet");
                    }
                  },
                  backgroundColor: COLORS.kBrightBlueColor,
                  icon: Assets.svg.audioCallIcon.svg(
                    color: COLORS.kDarkBlueColor,
                  ),
                ),
                CustomSizes.largeSizedBoxWidth,
                CircleIconButton(
                  onPressed: () {
                    Get.back();

                    if (!isWifiDirect) {
                      Get.toNamed(
                        Routes.CALL,
                        arguments: CallViewArgumentsModel(
                            session: null,
                            callId: null,
                            user: user,
                            enableVideo: true,
                            isAudioCall: false),
                      );
                    } else {
                      Get.snackbar("Wifi Direct", "Calling over wifi direct are not supported yet");
                    }
                  },
                  backgroundColor: COLORS.kBrightBlueColor,
                  icon: Assets.svg.videoCallIcon.svg(
                    color: COLORS.kDarkBlueColor,
                  ),
                ),
              ],
            ),
            CustomSizes.largeSizedBoxHeight,
            const Divider(
              color: COLORS.kBrightBlueColor,
              thickness: 1,
            ),
            CustomSizes.mediumSizedBoxHeight,
            Padding(
              padding: CustomSizes.iconListPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildIconTextButton(
                    //Todo: Add User Info onPressed
                    onPressed: () {},
                    icon: Assets.svg.infoIcon.svg(width: 20, height: 20),
                    title: user.isContact
                        ? LocaleKeys.newChat_userBottomSheet_contactInfo.tr
                        : LocaleKeys.newChat_userBottomSheet_userInfo.tr,
                  ),
                  !user.isContact
                      ? _buildIconTextButton(
                          onPressed: () {
                            Get.back();

                            Get.toNamed(
                              Routes.ADD_CONTACTS,
                              arguments: AddContactsViewArgumentsModel(user: user),
                            );
                          },
                          icon: Assets.svg.addToContactsIcon.svg(width: 20, height: 20),
                          title: LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                        )
                      : _buildIconTextButton(
                          onPressed: () async {
                            Get.back();
                            await Get.dialog(RemoveContactsDialog(
                              userName: user.name,
                            )).then((result) async {
                              if (result is bool && result == true) {
                                print("result   $result");

                                await _deleteContact();
                              }
                            });
                          },
                          icon: Assets.svg.removeContact.svg(width: 20, height: 20),
                          title: LocaleKeys.newChat_userBottomSheet_RemoveFromContacts.tr,
                        ),
                  _buildIconTextButton(
                    //Todo: Block onPressed
                    onPressed: () {},
                    iconBgColor: COLORS.kStatesErrorBackgroundColor,
                    icon: Assets.svg.blockIcon.svg(width: 20, height: 20),
                    title: LocaleKeys.newChat_userBottomSheet_block.tr,
                  ),
                  CustomSizes.largeSizedBoxHeight,
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Future<void> _deleteContact() async {
    await contactRepository
        .deleteContactById(
          user.walletAddress,
        )
        .then((value) => print("object deleted  $value "));
  }

  Widget _buildIconTextButton({
    VoidCallback? onPressed,
    required String title,
    required Widget icon,
    Color iconBgColor = COLORS.kBrightBlueColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: iconBgColor,
            ),
            child: icon,
          ),
          CustomSizes.mediumSizedBoxWidth,
          Text(
            title,
            style: TEXTSTYLES.kLinkBig.copyWith(
              color: COLORS.kDarkBlueColor,
            ),
          )
        ],
      ),
    );
  }
}

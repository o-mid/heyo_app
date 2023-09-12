import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/contacts/widgets/removeContactsDialog.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class UserPreviewWidget extends GetView<UserPreview> {
  final UserModel user;
  const UserPreviewWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isWifiDirect = controller.isWifiDirectConnection.value;
    return SingleChildScrollView(
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
                style: TEXTSTYLES.kHeaderLarge
                    .copyWith(color: COLORS.kDarkBlueColor),
              ),
              CustomSizes.smallSizedBoxWidth,
              user.isVerified
                  ? Assets.svg.verifiedWithBluePadding.svg(
                      alignment: Alignment.center, height: 24.w, width: 24.w)
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
                    print('UserPreviewWidget isWifiDirect $isWifiDirect');
                    isWifiDirect
                        ? Get.toNamed(
                            Routes.WIFI_DIRECT_CONNECT,
                            arguments: user,
                          )
                        : Get.toNamed(
                            Routes.MESSAGES,
                            arguments: MessagesViewArgumentsModel(
                              coreId: user.coreId,
                              iconUrl: user.iconUrl,
                              connectionType: MessagingConnectionType.internet,
                            ),
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
                        callId: null,
                        // convert userModel to callUserModel
                        user: user.toCallUserModel(),
                        enableVideo: false,
                        isAudioCall: true,
                      ),
                    );
                  } else {
                    Get.snackbar(
                      "Wifi Direct",
                      "Calling over wifi direct are not supported yet",
                    );
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
                        callId: null,
                        // convert userModel to callUserModel
                        user: user.toCallUserModel(),
                        enableVideo: true,
                        isAudioCall: false,
                      ),
                    );
                  } else {
                    Get.snackbar(
                      "Wifi Direct",
                      "Calling over wifi direct are not supported yet",
                    );
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
            height: 1,
          ),
          CustomSizes.smallSizedBoxHeight,
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
                            arguments: AddContactsViewArgumentsModel(
                              coreId: user.coreId,
                              iconUrl: user.iconUrl,
                            ),
                          );
                        },
                        icon: Assets.svg.addToContactsIcon
                            .svg(width: 20, height: 20),
                        title:
                            LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                      )
                    : _buildIconTextButton(
                        onPressed: () async {
                          Get.back();
                          await Get.dialog(
                            RemoveContactsDialog(
                              userName: user.name,
                            ),
                          ).then((result) async {
                            if (result is bool && result == true) {
                              print("result   $result");

                              await controller
                                  .deleteContact(user.walletAddress);
                            }
                          });
                        },
                        icon:
                            Assets.svg.removeContact.svg(width: 20, height: 20),
                        title: LocaleKeys
                            .newChat_userBottomSheet_RemoveFromContacts.tr,
                      ),
                _buildIconTextButton(
                  onPressed: () {
                    //Todo:  Blocking Implimentation
                    Get.rawSnackbar(
                      messageText: Text(
                        "Blocking feature is in development phase",
                        style: TEXTSTYLES.kBodySmall
                            .copyWith(color: COLORS.kDarkBlueColor),
                        textAlign: TextAlign.center,
                      ),
                      //  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                      backgroundColor: COLORS.kAppBackground,
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      margin: const EdgeInsets.only(top: 20),
                      boxShadows: [
                        BoxShadow(
                          color: const Color(0xFF466087).withOpacity(0.1),
                          offset: const Offset(0, 3),
                          blurRadius: 10,
                        ),
                      ],
                      borderRadius: 8,
                    );
                    return;
                  },
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
    );
  }
}

Widget _buildIconTextButton({
  VoidCallback? onPressed,
  required String title,
  required Widget icon,
  Color iconBgColor = COLORS.kBrightBlueColor,
}) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
    ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/contacts/widgets/removeContactsDialog.dart';
import 'package:heyo/app/modules/messages/utils/chat_Id_generator.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class UserPreviewWidget extends GetView<UserPreviewController> {
  const UserPreviewWidget({
    required this.coreId,
    //required this.name,
    super.key,
    //this.isVerified = false,
    //this.isContact = false,
  });

  final String coreId;
  //final String name;
  //final bool isVerified;
  //final bool isContact;

  @override
  Widget build(BuildContext context) {
    final isWifiDirect = controller.isWifiDirectConnection.value;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSizes.largeSizedBoxHeight,
          CustomCircleAvatar(coreId: coreId, size: 64),
          CustomSizes.mediumSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.name.value,
                style: TEXTSTYLES.kHeaderLarge
                    .copyWith(color: COLORS.kDarkBlueColor),
              ),
              //CustomSizes.smallSizedBoxWidth,
              //if (isVerified)
              //  Assets.svg.verifiedWithBluePadding.svg(
              //    height: 24.w,
              //    width: 24.w,
              //  )
              //else
              //  const SizedBox(),
            ],
          ),
          CustomSizes.smallSizedBoxHeight,
          Text(
            coreId.shortenCoreId,
            style: TEXTSTYLES.kBodySmall.copyWith(
              color: COLORS.kTextBlueColor,
            ),
          ),
          CustomSizes.largeSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleIconButton(
                onPressed: () {
                  if (coreId.isEmpty) {
                    return;
                  } else {
                    Get.back();
                    isWifiDirect
                        ? Get.toNamed(
                            Routes.WIFI_DIRECT_CONNECT,
                            arguments: MessagesViewArgumentsModel(
                                connectionType: MessagingConnectionType.wifiDirect,
                                participants: [
                                  MessagingParticipantModel(
                                    coreId: coreId,
                                    chatId: ChatIdGenerator.generate(),
                                  )
                                ]),
                          )
                        : Get.toNamed(
                            Routes.MESSAGES,
                            arguments: MessagesViewArgumentsModel(
                              participants: [
                                MessagingParticipantModel(
                                  coreId: coreId,
                                  chatId: ChatIdGenerator.generate(),
                                ),
                              ],
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
                        members: [coreId],
                        isAudioCall: true,
                      ),
                    );
                  } else {
                    SnackBarWidget.info(
                      title: 'Wifi Direct',
                      message: 'Calling over wifi direct are not supported yet',
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
                        members: [coreId],
                        isAudioCall: false,
                      ),
                    );
                  } else {
                    SnackBarWidget.info(
                      title: 'Wifi Direct',
                      message: 'Calling over wifi direct are not supported yet',
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
                  onPressed: () {
                    if (controller.isContact.isTrue) {
                      Get.toNamed(
                        Routes.ADD_CONTACTS,
                        arguments: AddContactsViewArgumentsModel(
                          coreId: coreId,
                        ),
                      );
                    }
                  },
                  icon: Assets.svg.infoIcon.svg(width: 20, height: 20),
                  title: controller.isContact.isTrue
                      ? LocaleKeys.newChat_userBottomSheet_contactInfo.tr
                      : LocaleKeys.newChat_userBottomSheet_userInfo.tr,
                ),
                if (controller.isContact.isFalse)
                  _buildIconTextButton(
                    onPressed: () {
                      Get
                        ..back()
                        ..toNamed(
                          Routes.ADD_CONTACTS,
                          arguments: AddContactsViewArgumentsModel(
                            coreId: coreId,
                          ),
                        );
                    },
                    icon: Assets.svg.addToContactsIcon.svg(
                      width: 20,
                      height: 20,
                    ),
                    title: LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                  )
                else
                  _buildIconTextButton(
                    onPressed: () async {
                      Get.back();
                      await Get.dialog(
                        RemoveContactsDialog(
                          userName: controller.name.value,
                        ),
                      ).then((result) async {
                        if (result is bool && result == true) {
                          print("result   $result");

                          await controller.deleteContact(coreId);
                        }
                      });
                    },
                    icon: Assets.svg.removeContact.svg(width: 20, height: 20),
                    title: LocaleKeys
                        .newChat_userBottomSheet_RemoveFromContacts.tr,
                  ),
                _buildIconTextButton(
                  onPressed: () {
                    //Todo:  Blocking Implimentation
                    SnackBarWidget.info(
                      message: 'Blocking feature is in development phase',
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
  required String title,
  required Widget icon,
  VoidCallback? onPressed,
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
        ),
      ],
    ),
  );
}

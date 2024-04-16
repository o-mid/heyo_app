import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import '../../../../../app/modules/shared/utils/screen-utils/buttons/custom_button.dart';

class EmptyChatsWidget extends StatelessWidget {
  const EmptyChatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 67),
            _buildEmptyChats(),
            const SizedBox(height: 76),
            Text(
              LocaleKeys.HomePage_Chats_emptyState_title.tr,
              style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
            ),
            const SizedBox(height: 9),
            Text(
              LocaleKeys.HomePage_Chats_emptyState_subtitle.tr,
              style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
            ),
            const SizedBox(height: 30),
            CustomButton.primarySmall(
              // Todo
              onTap: () => Get.toNamed(
                Routes.NEW_CHAT,
                arguments: NewChatArgumentsModel(
                  openInviteBottomSheet: true,
                ),
              ),
              color: COLORS.kGreenLighterColor,
              title: LocaleKeys.HomePage_Chats_emptyState_invite.tr,
              style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          _buildRecipientChat(width: 143, profile: Assets.png.profile1),
          _buildSenderChat(
            width: 68,
            profile: Assets.png.profile2,
            child: const Text(
              "🍕 😊",
              textAlign: TextAlign.center,
            ),
          ),
          _buildRecipientChat(width: 121, profile: Assets.png.profile3),
          _buildRecipientChat(
            width: 42,
            profile: Assets.png.profile4,
            bottomMargin: 0,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xffd2d2d2),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 4, bottom: 4),
                  decoration: const BoxDecoration(
                    color: COLORS.kDarkBlueColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xffd2d2d2),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientChat({
    required AssetGenImage profile,
    required double width,
    double bottomMargin = 32,
    Widget? child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Row(
        children: [
          _buildAvatar(profile),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            width: width,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: COLORS.kPinCodeDeactivateColor,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSenderChat({
    required AssetGenImage profile,
    required double width,
    double bottomMargin = 32,
    Widget? child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Row(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            width: width,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: COLORS.kGreenMainColor,
            ),
            child: child,
          ),
          const SizedBox(width: 16),
          _buildAvatar(profile),
        ],
      ),
    );
  }

  Widget _buildAvatar(AssetGenImage profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: profile.image(
        width: 40,
        height: 40,
      ),
    );
  }
}

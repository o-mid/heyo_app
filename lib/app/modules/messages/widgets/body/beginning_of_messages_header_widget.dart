import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../new_chat/data/models/user_model.dart';

class BeginningOfMessagesHeaderWidget extends StatelessWidget {
  final String chatName;
  final List<String> participantsCoreIds;

  const BeginningOfMessagesHeaderWidget({
    Key? key,
    required this.participantsCoreIds,
    required this.chatName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w).copyWith(top: 0, bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      decoration: _containerDecoration(),
      child: Column(
        children: [
          _buildUserAvatar(),
          CustomSizes.mediumSizedBoxHeight,
          _buildUserNameRow(),
          SizedBox(height: 4.h),
          _buildCoreIdText(),
          CustomSizes.mediumSizedBoxHeight,
          _buildEncryptedMessagingText(),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 1,
        color: COLORS.kPinCodeDeactivateColor,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildUserAvatar() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 62,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: participantsCoreIds.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CustomCircleAvatar(coreId: participantsCoreIds[index], size: 62);
              },
            ),
          ),
        ]);
  }

  Widget _buildUserNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          chatName,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
        ),
        CustomSizes.smallSizedBoxWidth,
        _buildVerifiedIcon(),
      ],
    );
  }

  Widget _buildVerifiedIcon() {
    return Container(
      width: 24.w,
      height: 24.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: const BoxDecoration(
        color: COLORS.kBlueColor,
        shape: BoxShape.circle,
      ),
      child: Assets.svg.verified.svg(color: COLORS.kWhiteColor),
    );
  }

  Widget _buildCoreIdText() {
    return Text(
      "CB13...586A",
      style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
    );
  }

  Widget _buildEncryptedMessagingText() {
    return Text(
      LocaleKeys.MessagesPage_endToEndEncryptedMessaging.trParams(
        {
          "name": chatName,
        },
      ),
      style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
      textAlign: TextAlign.center,
    );
  }
}

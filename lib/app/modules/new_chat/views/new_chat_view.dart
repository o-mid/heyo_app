import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/fonts.dart';
import '../controllers/new_chat_controller.dart';

class NewChatView extends GetView<NewChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _newchatAppbar(),
      body: Container(
        padding: CustomSizes.mainContentPadding,
        child: _emptyContacts(),
      ),
    );
  }

  AppBar _newchatAppbar() {
    return AppBar(
      backgroundColor: COLORS.kGreenMainColor,
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

class _emptyContacts extends StatelessWidget {
  const _emptyContacts({
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

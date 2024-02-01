import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';

class RecentContactsWidget extends StatelessWidget {
  const RecentContactsWidget({Key? key, required this.users, required this.userSelect})
      : super(key: key);
  final Function(UserModel user) userSelect;
  final RxList<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.largeSizedBoxHeight,
        Padding(
          padding: CustomSizes.contentPaddingWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.forwardMassagesPage_recentContacts.tr,
                style: TEXTSTYLES.kLinkSmall.copyWith(color: COLORS.kTextBlueColor),
              ),
              CustomSizes.smallSizedBoxHeight,
              ListView.builder(
                itemCount: users.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.h,
                      top: 8.h,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        userSelect(users[index]);
                      },
                      child: UserWidget(
                        coreId: users[index].coreId,
                        name: users[index].name,
                        walletAddress: users[index].walletAddress,
                        isOnline: users[index].isOnline,
                        isVerified: users[index].isVerified,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        CustomSizes.mediumSizedBoxHeight,
        const Divider(
          color: COLORS.kBrightBlueColor,
          thickness: 8,
        ),
      ],
    );
  }
}

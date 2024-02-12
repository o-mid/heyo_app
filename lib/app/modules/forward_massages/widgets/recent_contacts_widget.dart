import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../controllers/forward_massages_controller.dart';

class RecentContactsWidget extends StatelessWidget {
  const RecentContactsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForwardMassagesController>();
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
              Obx(
                () => ListView.builder(
                  itemCount: controller.users.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final user = controller.users[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => controller.setSelectedUser(user.coreId),
                        child: UserWidget(
                          coreId: user.coreId,
                          name: user.name,
                          walletAddress: user.walletAddress,
                          isOnline: user.isOnline,
                          isVerified: user.isVerified,
                        ),
                      ),
                    );
                  },
                ),
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

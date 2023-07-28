import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CalleeOrCallerInfoWidget extends StatelessWidget {
  final UserModel user;

  const CalleeOrCallerInfoWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCircleAvatar(
          url: user.iconUrl,
          size: 64,
        ),
        SizedBox(height: 24.h),
        Text(
          (user.isContact) ? user.name : user.coreId.shortenCoreId,
          style: TEXTSTYLES.kHeaderLarge.copyWith(
            color: COLORS.kWhiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          user.walletAddress.shortenCoreId,
          style: TEXTSTYLES.kBodySmall.copyWith(
            color: COLORS.kWhiteColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

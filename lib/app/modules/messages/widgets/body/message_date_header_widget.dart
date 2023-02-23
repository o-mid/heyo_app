import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/utils/constants/colors.dart';
import '../../../shared/utils/constants/textStyles.dart';
import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';

class MessagesDateHeaderWidget extends StatelessWidget {
  final String headerValue;
  const MessagesDateHeaderWidget({Key? key, required this.headerValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.mediumSizedBoxHeight,
        Text(
          headerValue,
          style: TEXTSTYLES.kBodyTag.copyWith(
            color: COLORS.kTextBlueColor,
            fontSize: 10.sp,
          ),
        ),
        CustomSizes.mediumSizedBoxHeight,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';

class InitialRecorderWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onRecord;
  const InitialRecorderWidget({
    Key? key,
    required this.onCancel,
    required this.onRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          splashRadius: 20.r,
          onPressed: onCancel,
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kDarkBlueColor,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: onRecord,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.w,
                    color: COLORS.kStatesErrorColor,
                  ),
                ),
                child: Assets.svg.recordVoiceCircleIcon.svg(
                  width: 48.w,
                  height: 48.w,
                  color: COLORS.kStatesErrorColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
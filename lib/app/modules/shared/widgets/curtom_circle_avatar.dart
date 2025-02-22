import 'package:core_blockies/core_blockies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  CustomCircleAvatar({
    required this.coreId,
    required this.size,
    this.onTap,
    super.key,
    this.isOnline = false,
  });

  final String coreId;
  final double size;
  final bool isOnline;

  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CoreBlockies(
              coreId: coreId,
              size: size.w,
            ),
          ),

          // The two following widgets are to show a green online badge on chat icon
          // and a white border around the green badge. It could be done with only one
          // Container with a border, but this also creates a thin outer border after the white
          // one which is not desirable. As a solution this is used for now
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: COLORS.kWhiteColor,
                  ),
                ),
              ),
            ),
          if (isOnline)
            Positioned(
              bottom: 2.w,
              right: 2.w,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: COLORS.kOnlineBadgeColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

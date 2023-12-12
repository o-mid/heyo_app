import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    required this.url,
    required this.size,
    super.key,
    this.isOnline = false,
    this.isMockData = false,
  });

  final String url;
  final double size;
  final bool isOnline;
  final bool isMockData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.w,
          height: size.w,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: !isMockData || url.isNotEmpty ? Image.network(url) : Container(color: Colors.grey),
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
    );
  }
}

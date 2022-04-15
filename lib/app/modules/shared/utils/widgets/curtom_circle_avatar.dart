import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String url;
  final double size;
  final bool isOnline;
  const CustomCircleAvatar({Key? key, required this.url, required this.size, this.isOnline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              url,
            ),
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
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: COLORS.kWhiteColor,
                ),
              ),
            ),
          ),
        if (isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: COLORS.kStatesLightSuccessColor,
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'curtom_circle_avatar.dart';

class StackedAvatars extends StatelessWidget {
  final String coreId1;
  final String coreId2;
  final double avatarSize;
  final double overLapSize;

  const StackedAvatars({
    Key? key,
    required this.avatarSize,
    required this.coreId1,
    required this.coreId2,
    this.overLapSize = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: avatarSize * 2,
      height: avatarSize * 2 + overLapSize,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: overLapSize,
            child: CustomCircleAvatar(
              coreId: coreId1,
              size: avatarSize,
            ),
          ),
          Positioned(
            left: overLapSize * 2,
            top: overLapSize,
            child: CustomCircleAvatar(
              coreId: coreId2,
              size: avatarSize,
            ),
          ),
        ],
      ),
    );
  }
}

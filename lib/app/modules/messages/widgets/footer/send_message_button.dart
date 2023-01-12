import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../generated/assets.gen.dart';
import '../../controllers/messages_controller.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    Key? key,
    this.padding,
    required this.onTap,
  }) : super(key: key);
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: padding,
        child: Assets.svg.sendIcon.svg(
          height: 20.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

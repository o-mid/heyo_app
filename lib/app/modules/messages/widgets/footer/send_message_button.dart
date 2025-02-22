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
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        minimumSize: Size.zero,
        padding: const EdgeInsets.only(
          left: 8,
        ),
        side: const BorderSide(
          color: Colors.transparent,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Assets.svg.sendIcon.svg(
          height: 22.h,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

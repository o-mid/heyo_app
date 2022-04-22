import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/generated/assets.gen.dart';

class ModifiedAlertDialog extends StatelessWidget {
  final Widget alertContent;
  final double? padding;
  final Function? onClose;
  final bool hideCloseSign;
  ModifiedAlertDialog(
      {Key? key,
      this.onClose,
      required this.alertContent,
      this.padding,
      this.hideCloseSign = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: WillPopScope(
        onWillPop: () async {
          if (onClose != null) onClose!();
          return Future.value(!hideCloseSign);
        },
        child: AlertDialog(
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 40.w),
              Visibility(
                visible: !hideCloseSign,
                child: removeSign(onPressed: () {
                  if (onClose != null)
                    onClose!();
                  else
                    Get.back();
                }),
              ),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          content: Wrap(
            children: [
              Container(
                width: Get.width - 40.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: padding ?? 20.0.w,
                  left: padding ?? 20.0.w,
                  bottom: 40.0.w,
                ),
                child: alertContent,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget removeSign({required Function onPressed, bool hasError = false}) {
  return InkWell(
    borderRadius: BorderRadius.circular(100),
    onTap: () {
      onPressed();
    },
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Assets.svg.closeSign.svg(
        width: 20.w,
        height: 20.w,
      ),
    ),
  );
}

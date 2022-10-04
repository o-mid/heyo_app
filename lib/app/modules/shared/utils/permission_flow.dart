import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/permission_dialog.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionFlow {
  final Widget indicatorIcon;
  final String subtitle;
  final Permission permission;

  PermissionFlow({
    required this.indicatorIcon,
    required this.subtitle,
    required this.permission,
  });

  Future<bool> start() async {
    if (await permission.isDenied) {
      bool result = await Get.dialog(
        PermissionDialog(
          indicatorIcon: indicatorIcon,
          title: LocaleKeys.Permissions_AllowAccess.tr,
          subtitle: subtitle,
        ),
      );

      if (!result) {
        return false;
      }

      if (!await permission.request().isGranted) {
        return false;
      }
    }

    return true;
  }
}

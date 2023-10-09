import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
//import 'appbar_action_bottom_sheet.dart';
import 'filter_bottom_sheet.dart';

class AppBarAddParticipate extends AppBarWidget {
  AppBarAddParticipate(this.controller, {super.key})
      : super(
          title: LocaleKeys.addParticipate_appbarTitle.tr,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => openFiltersBottomSheet(controller: controller),
              icon: Assets.svg.filterIcon.svg(),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              controller.clearRxList();
              Get.back();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            ),
          ),
        );
  final AddParticipateController controller;
}

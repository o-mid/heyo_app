import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
import 'appbar_action_bottom_sheet.dart';
import 'filter_bottom_sheet.dart';

class AppBarAddParticipate extends AppBarWidget {
  final AddParticipateController controller;

  AppBarAddParticipate(this.controller, {super.key})
      : super(
          title: LocaleKeys.addParticipate_appbarTitle.tr,
          actions: [
            IconButton(
              onPressed: () => openFiltersBottomSheet(controller: controller),
              icon: Assets.svg.filterIcon.svg(),
            ),
            IconButton(
              onPressed: () => openAppbarActionBottomSheet(
                profileLink: controller.profileLink,
              ),
              icon: Assets.svg.dotColumn.svg(
                width: 5,
              ),
            ),
          ],
        );
}

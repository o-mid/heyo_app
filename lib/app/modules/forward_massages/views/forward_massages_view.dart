import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/forward_massages_controller.dart';

class ForwardMassagesView extends GetView<ForwardMassagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.forwardMassagesPage_appbar.tr,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kWhiteColor,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: COLORS.kGreenMainColor,
      ),
      body: const Center(
        child: Text(
          'ForwardMassagesView is working',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/fonts.dart';
import '../controllers/new_chat_controller.dart';

class NewChatView extends GetView<NewChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.HomePage_title.tr,
          style: TextStyle(
            fontWeight: FONTS.Bold,
            fontFamily: FONTS.interFamily,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          'NewChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/share_files_controller.dart';

class ShareFilesView extends GetView<ShareFilesController> {
  const ShareFilesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _shareFilesAppbar(),
      body: const Center(
        child: Text(
          'ShareFilesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

AppBar _shareFilesAppbar() {
  return AppBar(
    backgroundColor: COLORS.kGreenMainColor,
    elevation: 0,
    centerTitle: false,
    title: Text(
      LocaleKeys.newChat_newChatAppBar.tr,
      style: const TextStyle(
        fontWeight: FONTS.Bold,
        fontFamily: FONTS.interFamily,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: Assets.svg.searchIcon.svg(),
      ),
      IconButton(
          onPressed: () {},
          icon: Assets.svg.folderIcon.svg(
            width: 5,
          )),
    ],
    automaticallyImplyLeading: true,
  );
}

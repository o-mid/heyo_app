import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _buildChats(controller.chats.value),
      ),
    );
  }

  Widget _buildChats(List<ChatModel> chats) {
    return chats.length == 0
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.HomePage_Chats_emptyState_title.tr,
                  style: TextStyle(
                    fontWeight: FONTS.Bold,
                    fontFamily: FONTS.interFamily,
                    fontSize: 19,
                    color: COLORS.kDarkBlueColor,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  LocaleKeys.HomePage_Chats_emptyState_subtitle.tr,
                  style: TextStyle(
                    fontFamily: FONTS.interFamily,
                    fontSize: 13,
                    color: COLORS.kTextSoftBlueColor,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  // Todo
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: COLORS.kGreenLighterColor,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    child: Text(
                      LocaleKeys.HomePage_Chats_emptyState_invite.tr,
                      style: TextStyle(
                        color: COLORS.kGreenMainColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: ChatWidget(chat: chats[index]),
              );
            },
          );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../../generated/assets.gen.dart';
import '../../new_chat/controllers/new_chat_controller.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';
import '../../shared/widgets/list_header_widget.dart';
import '../controllers/new_group_chat_controller.dart';

class ContactListWidget extends StatelessWidget {
  ContactListWidget({super.key});

  final controller = Get.find<NewGroupChatController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contacts = controller.searchSuggestions;
      final searchMode = controller.inputController.text.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchMode) _buildSearchModeHeader(),
          ListView.separated(
            shrinkWrap: true,
            itemCount: contacts.length,
            scrollDirection: Axis.vertical,
            separatorBuilder: (_, __) => searchMode
                ? CustomSizes.mediumSizedBoxHeight
                : const SizedBox.shrink(),
            itemBuilder: (context, index) => _buildContactListItem(index),
          ),
        ],
      );
    });
  }

  Widget _buildSearchModeHeader() {
    return Column(
      children: [
        Text(
          LocaleKeys.newChat_searchResults.tr,
          style:
              TEXTSTYLES.kLinkSmall.copyWith(color: COLORS.kTextSoftBlueColor),
        ),
        CustomSizes.mediumSizedBoxHeight,
      ],
    );
  }

  Widget _buildContactListItem(int index) {
    final contacts = controller.searchSuggestions;
    final searchMode = controller.inputController.text.isNotEmpty;
    //this will grab the current user and
    // extract the first character from its name
    final currentUsernameFirstChar = contacts[index].name.characters.first;
    //this will grab the next user in the list if its not null and
    // extract the first character from its name
    final nextUsernameFirstChar = contacts.indexOf(contacts.last) > index + 1
        ? contacts[index + 1].name.characters.first
        : "";
    var suggestedUser = contacts[index];
    return Column(
      children: [
        if (currentUsernameFirstChar != nextUsernameFirstChar && !searchMode)
          ListHeaderWidget(
            title: contacts[index].name.characters.first.toUpperCase(),
          )
        else
          const SizedBox(),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            controller.inputFocusNode.unfocus();
            controller.handleItemTap(
              suggestedUser,
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCircleAvatar(
                coreId: suggestedUser.coreId,
                size: 48,
                //isOnline: suggestedUser.isOnline,
              ),
              CustomSizes.mediumSizedBoxWidth,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        suggestedUser.name,
                        style: TEXTSTYLES.kChatName
                            .copyWith(color: COLORS.kDarkBlueColor),
                      ),
                      CustomSizes.smallSizedBoxWidth,
                      //if (suggestedUser.isVerified) Assets.svg.verifiedWithBluePadding.svg(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestedUser.coreId.shortenCoreId,
                    maxLines: 1,
                    style: TEXTSTYLES.kChatText
                        .copyWith(color: COLORS.kTextBlueColor),
                  ),
                ],
              ),
              const Spacer(),
              if (controller.selectedCoreids
                  .any((element) => element.coreId == suggestedUser.coreId))
                const Icon(Icons.check_circle, color: COLORS.kGreenMainColor)
              else
                const Icon(Icons.circle_outlined, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}

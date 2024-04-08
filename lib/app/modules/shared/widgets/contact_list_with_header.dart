import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/new_chat/controllers/new_chat_controller.dart';
import 'package:heyo/app/modules/new_chat/widgets/user_widget.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class ContactListWithHeader extends GetView<NewChatController> {
  final List<ContactModel> contacts;
  final bool searchMode;
  final bool showAudioCallButton;
  final bool showVideoCallButton;
  const ContactListWithHeader({
    Key? key,
    required this.contacts,
    required this.searchMode,
    this.showAudioCallButton = false,
    this.showVideoCallButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchMode) ...[
          Text(
            LocaleKeys.newChat_searchResults.tr,
            style: TEXTSTYLES.kLinkSmall
                .copyWith(color: COLORS.kTextSoftBlueColor),
          ),
          CustomSizes.mediumSizedBoxHeight,
        ],
        ListView.separated(
          shrinkWrap: true,
          itemCount: contacts.length,
          separatorBuilder: (_, __) => searchMode
              ? CustomSizes.mediumSizedBoxHeight
              : const SizedBox.shrink(),
          itemBuilder: (BuildContext context, int index) {
            //this will grab the current user and
            // extract the first character from its name
            String currentUsernameFirstChar =
                contacts[index].name.characters.first;
            //this will grab the next user in the list if its not null and
            // extract the first character from its name
            String nextUsernameFirstChar =
                contacts.indexOf(contacts.last) > index + 1
                    ? contacts[index + 1].name.characters.first
                    : "";
            var suggestedUser = contacts[index];
            return Column(
              children: [
                currentUsernameFirstChar != nextUsernameFirstChar && !searchMode
                    ? ListHeaderWidget(
                        title:
                            contacts[index].name.characters.first.toUpperCase(),
                      )
                    : const SizedBox(),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    controller.inputFocusNode.unfocus();
                    var contact = contacts[index];
                    Get.find<UserPreviewController>().openUserPreview(
                      coreId: contact.coreId,
                      //name: contact.name,
                      //isVerified: contact.isVerified,
                      //isContact: contact.isContact,
                    );
                  },
                  child: UserWidget(
                    coreId: suggestedUser.coreId,
                    name: suggestedUser.name,
                    walletAddress: suggestedUser.coreId,
                    showAudioCallButton: showAudioCallButton,
                    showVideoCallButton: showVideoCallButton,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

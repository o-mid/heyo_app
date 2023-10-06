import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/widgets/addable_user_widget.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';
import 'package:heyo/generated/locales.g.dart';

class ContactListWithHeaderAddParticipate
    extends GetView<AddParticipateController> {
  final List<AllParticipantModel> contacts;
  final bool searchMode;

  const ContactListWithHeaderAddParticipate({
    Key? key,
    required this.contacts,
    required this.searchMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchMode) ...[
            Text(
              LocaleKeys.newChat_searchResults.tr,
              style: TEXTSTYLES.kLinkSmall.copyWith(
                color: COLORS.kTextSoftBlueColor,
              ),
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
              return !controller.isSelected(suggestedUser)
                  ? Column(
                      children: [
                        currentUsernameFirstChar != nextUsernameFirstChar &&
                                !searchMode
                            ? ListHeaderWidget(
                                title: contacts[index]
                                    .name
                                    .characters
                                    .first
                                    .toUpperCase(),
                              )
                            : const SizedBox(),
                        AddableUserWidget(user: suggestedUser),
                      ],
                    )
                  : Container();
            },
          ),
        ],
      );
    });
  }
}

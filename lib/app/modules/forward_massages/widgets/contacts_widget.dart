import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../../shared/widgets/list_header_widget.dart';

class contactsWidget extends StatelessWidget {
  const contactsWidget({
    Key? key,
    required this.searchSuggestions,
    required this.isTextInputFocused,
    required this.userSelect,
  }) : super(key: key);
  final RxList<UserModel> searchSuggestions;
  final RxBool isTextInputFocused;
  final Function(UserModel user) userSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.largeSizedBoxHeight,
        Padding(
          padding: CustomSizes.contentPaddingWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isTextInputFocused.value
                    ? LocaleKeys.forwardMassagesPage_contacts.tr
                    : LocaleKeys.forwardMassagesPage_OtherContacts.tr,
                style: TEXTSTYLES.kLinkSmall
                    .copyWith(color: COLORS.kTextBlueColor),
              ),
              ListView.builder(
                itemCount: searchSuggestions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  //this will grab the current user and
                  // extract the first character from its name
                  String _currentUsernamefirstchar =
                      searchSuggestions[index].name.characters.first;
                  //this will grab the next user in the list if its not null and
                  // extract the first character from its name
                  String _nextUsernamefirstchar =
                      searchSuggestions.indexOf(searchSuggestions.last) >
                              index + 1
                          ? searchSuggestions[index + 1].name.characters.first
                          : "";
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.h,
                      top: 8.h,
                    ),
                    child: Column(
                      children: [
                        _currentUsernamefirstchar != _nextUsernamefirstchar
                            ? ListHeaderWidget(
                                title: searchSuggestions[index]
                                    .name
                                    .characters
                                    .first
                                    .toUpperCase())
                            : const SizedBox(),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            userSelect(searchSuggestions[index]);
                          },
                          child: UserWidget(User: searchSuggestions[index]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

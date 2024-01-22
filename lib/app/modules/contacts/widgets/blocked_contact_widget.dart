import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/contacts/controllers/contacts_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/item_section_widget.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class BlockedContactWidget extends GetView<ContactsController> {
  const BlockedContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.largeSizedBoxHeight,
        ItemSectionWidget(
          icon: Assets.svg.blockedUser.svg(
            theme: const SvgTheme(currentColor: COLORS.kStatesErrorColor),
          ),
          iconBackgroundColor: COLORS.kBrightBlueColor,
          title: LocaleKeys.BlockUserPage_BlockedContacts.tr,
          trailing: Text(controller.blockedContacts.length.toString()),
          onTap: () {
            //Todo:  Blocking Implimentation
            SnackBarWidget.info(
              message: 'Blocking Contacts feature is in development phase',
            );
          },
        ),
      ],
    );
  }
}

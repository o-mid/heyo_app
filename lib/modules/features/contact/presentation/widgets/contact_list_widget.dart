import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/user_list_tile_widget.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/contact/presentation/controllers/contact_controller.dart';

class ContactsListWidget extends ConsumerWidget {
  const ContactsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizes.largeSizedBoxHeight,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            LocaleKeys.ContactsPage_contactListHeader.trParams(
              {'count': contacts.value!.length.toString()},
            ),
            style: TEXTSTYLES.kLinkSmall.copyWith(
              color: COLORS.kTextSoftBlueColor,
            ),
          ),
        ),
        CustomSizes.smallSizedBoxHeight,
        ...contacts.value!.map(
          (contact) => UserListTileWidget(
            coreId: contact.coreId,
            name: contact.name,
            showAudioCallButton: true,
            showVideoCallButton: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/contacts/controllers/contacts_controller.dart';
import 'package:heyo/app/modules/contacts/widgets/blocked_contact_widget.dart';
import 'package:heyo/app/modules/contacts/widgets/contacts_list_widget.dart';
import 'package:heyo/app/modules/contacts/widgets/contacts_loading_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/locales.g.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.ContactsPage_appBarTitle.tr,
      ),
      body: Obx(() {
        if (controller.loading.isTrue) {
          return const ContactsLoadingWidget();
        } else {
          return const AnimateListWidget(
            children: [
              BlockedContactWidget(),
              Divider(thickness: 8, color: COLORS.kBrightBlueColor),
              ContactsListWidget(),
            ],
          );
        }
      }),
    );
  }
}

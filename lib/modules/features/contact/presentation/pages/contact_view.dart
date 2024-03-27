import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/contact/presentation/controllers/contact_controller.dart';
import 'package:heyo/modules/features/contact/presentation/widgets/blocked_contact_widget.dart';
import 'package:heyo/modules/features/contact/presentation/widgets/contacts_list_widget.dart';
import 'package:heyo/modules/features/contact/presentation/widgets/contacts_loading_widget.dart';

class ContactView extends ConsumerWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactNotifierProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.ContactsPage_appBarTitle.tr,
      ),
      body: contacts.when(
        data: (data) {
          return const AnimateListWidget(
            children: [
              BlockedContactWidget(),
              Divider(thickness: 8, color: COLORS.kBrightBlueColor),
              ContactsListWidget(),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const ContactsLoadingWidget(),
      ),
    );
  }
}

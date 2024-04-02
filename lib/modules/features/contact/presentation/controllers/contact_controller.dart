import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

final contactNotifierProvider =
    AsyncNotifierProvider<ContactController, List<ContactModel>>(
  () => ContactController(
    contactRepo: inject.get<ContactRepo>(),
  ),
);

class ContactController extends AsyncNotifier<List<ContactModel>> {
  ContactController({required this.contactRepo});

  //final blockedContacts = <ContactModel>[];
  final ContactRepo contactRepo;

  @override
  FutureOr<List<ContactModel>> build() {
    unawaited(listenToContactsStream());

    return getContacts();
  }

  Future<List<ContactModel>> getContacts() async {
    //blockedContacts.clear();
    //blockedContacts =
    //    contacts.where((element) => element.isBlocked).toList();

    return contactRepo.getContacts();
  }

  Future<void> listenToContactsStream() async {
    final contacts = state.value ?? [];

    (await contactRepo.getContactsStream()).listen((newContact) {
      // Add it to contact and sort it alphabetic
      contacts
        ..addAll(newContact)
        ..sort((a, b) => b.name.compareTo(a.name));

      state = AsyncData(contacts);

      //blockedContacts.value =
      //    contacts.where((element) => element.isBlocked).toList();

      //blockedContacts.refresh();
    });
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/presentation/models/contact_view_model/contact_view_model.dart';

final contactNotifierProvider =
    AsyncNotifierProvider<ContactController, List<ContactViewModel>>(
  () => ContactController(
    contactRepo: inject.get<ContactRepo>(),
  ),
);

class ContactController extends AsyncNotifier<List<ContactViewModel>> {
  ContactController({required this.contactRepo});

  //final blockedContacts = <ContactViewModel>[];
  final ContactRepo contactRepo;

  @override
  FutureOr<List<ContactViewModel>> build() {
    unawaited(listenToContactsStream());

    return getContacts();
  }

  Future<List<ContactViewModel>> getContacts() async {
    final contactUserModels = await contactRepo.getContacts();
    //blockedContacts.clear();
    //blockedContacts =
    //    contacts.where((element) => element.isBlocked).toList();

    final contacts = contactUserModels
        .map((contact) => contact.mapToContactViewModel())
        .toList();

    return contacts;
  }

  Future<void> listenToContactsStream() async {
    final contacts = state.value ?? [];

    (await contactRepo.getContactsStream()).listen((newContactUserModel) {
      // convert userModel to contactViewModel
      final contactViewModelList = newContactUserModel
          .map((contact) => contact.mapToContactViewModel())
          .toList();

      // Add it to contact and sort it alphabetic
      contacts
        ..addAll(contactViewModelList)
        ..sort((a, b) => b.name.compareTo(a.name));

      state = AsyncData(contacts);

      //blockedContacts.value =
      //    contacts.where((element) => element.isBlocked).toList();

      //blockedContacts.refresh();
    });
  }
}

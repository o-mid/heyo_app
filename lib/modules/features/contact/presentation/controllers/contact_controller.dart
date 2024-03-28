import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

final contactNotifierProvider =
    AsyncNotifierProvider<ContactController, List<UserModel>>(
  () => ContactController(
    contactRepo: inject.get<ContactRepo>(),
  ),
);

class ContactController extends AsyncNotifier<List<UserModel>> {
  ContactController({required this.contactRepo});

  final blockedContacts = <UserModel>[];
  final ContactRepo contactRepo;

  @override
  FutureOr<List<UserModel>> build() {
    unawaited(listenToContactsStream());

    return getContacts();
  }

  Future<List<UserModel>> getContacts() async {
    final contacts = await contactRepo.getContacts();
    blockedContacts.clear();
    //blockedContacts =
    //    contacts.where((element) => element.isBlocked).toList();
    return contacts;
  }

  Future<void> listenToContactsStream() async {
    final contacts = state.value ?? [];

    (await contactRepo.getContactsStream()).listen((newContacts) {
      contacts
        ..addAll(newContacts)
        ..sort((a, b) => b.name.compareTo(a.name));

      state = AsyncData(contacts);

      //blockedContacts.value =
      //    contacts.where((element) => element.isBlocked).toList();

      //blockedContacts.refresh();
    });
  }
}

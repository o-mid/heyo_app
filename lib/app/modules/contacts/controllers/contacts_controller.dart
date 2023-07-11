import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../new_chat/data/models/user_model.dart';

class ContactsController extends GetxController {
  final contacts = <UserModel>[].obs;
  final blockedContacts = <UserModel>[].obs;
  final ContactRepository contactRepo;
  late StreamSubscription _contactStreamSubscription;

  ContactsController({required this.contactRepo});

  @override
  Future<void> onInit() async {
    contacts.clear();
    blockedContacts.clear();
    await getContacts();
    await listenToContactsStream();
    super.onInit();
  }

  Future<void> getContacts() async {
    contacts.value = await contactRepo.getContacts();
    blockedContacts.value = contacts.where((element) => element.isBlocked).toList();
  }

  Future<void> listenToContactsStream() async {
    Stream<List<UserModel>> contactsStream = await contactRepo.getContactsStream();

    _contactStreamSubscription = contactsStream.listen((newContacts) {
      contacts.value = newContacts;

      contacts.sort((a, b) => b.name.compareTo(a.name));

      contacts.refresh();

      blockedContacts.value = contacts.where((element) => element.isBlocked).toList();

      blockedContacts.refresh();
    });
  }

  @override
  void onClose() {
    _contactStreamSubscription.cancel();
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}

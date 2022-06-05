import 'dart:async';

import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';

class ContactRepository {
  CacheContractor cacheContractor;

  ContactRepository({required this.cacheContractor});

  Future<List<UserContact>> getContacts() {
    return cacheContractor.getUserContacts();
  }

  Future addContact(UserContact userContact) {
    return cacheContractor.addUserContact(userContact);
  }

  Future<List<UserContact>> search(String query) async {
    List<UserContact> contacts = await getContacts();
    return contacts
        .where((element) => element.nickName.toString().toLowerCase().contains(query.toLowerCase())
        || element.coreId.startsWith(query))
        .toList();
  }
}

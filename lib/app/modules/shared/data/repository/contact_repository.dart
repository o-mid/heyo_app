import 'dart:async';

import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';

import '../../../new_chat/data/models/user_model.dart';

class ContactRepository {
  CacheContractor cacheContractor;

  ContactRepository({required this.cacheContractor});

  Future<List<UserModel>> getContacts() {
    return cacheContractor.getUserContacts();
  }

  Future addContact(UserModel userModel) {
    return cacheContractor.addUserContact(userModel);
  }

  Future<List<UserModel>> search(String query) async {
    List<UserModel> contacts = await getContacts();
    return contacts
        .where((element) =>
            element.nickname.toString().toLowerCase().contains(query.toLowerCase()) ||
            element.coreId.startsWith(query))
        .toList();
  }
}

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

  Future deleteUserContact(UserModel user) {
    return cacheContractor.deleteUserContact(user);
  }

  Future updateUserContact(UserModel user) {
    return cacheContractor.updateUserContact(user);
  }

  Future<UserModel?> getContactById(String userCoreId) {
    return cacheContractor.getContactById(userCoreId);
  }

  Future<List<UserModel>> getBlockedContacts() {
    return cacheContractor.getBlockedContacts();
  }

  Future<Stream<List<UserModel>>> getContactsStream() async {
    return cacheContractor.getContactsStream();
  }
}

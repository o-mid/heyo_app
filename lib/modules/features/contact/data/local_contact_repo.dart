import 'dart:async';

import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class LocalContactRepo implements ContactRepo {
  LocalContactRepo({required this.cacheContractor});
  CacheContractor cacheContractor;

  @override
  Future<List<UserModel>> getContacts() {
    return cacheContractor.getUserContacts();
  }

  @override
  Future<void> addContact(UserModel userModel) {
    return cacheContractor.addUserContact(userModel);
  }

  @override
  Future<List<UserModel>> search(String query) async {
    final contacts = await getContacts();
    return contacts
        .where(
          (element) =>
              element.nickname.toLowerCase().contains(query.toLowerCase()) ||
              element.coreId.startsWith(query),
        )
        .toList();
  }

  @override
  Future<void> deleteUserContact(UserModel user) async {
    return cacheContractor.deleteUserContact(user);
  }

  @override
  Future<dynamic> deleteContactById(String userCoreId) {
    return cacheContractor.deleteContactById(userCoreId);
  }

  @override
  Future<void> updateUserContact(UserModel user) {
    return cacheContractor.updateUserContact(user);
  }

  @override
  Future<UserModel?> getContactById(String userCoreId) {
    return cacheContractor.getContactById(userCoreId);
  }

  @override
  Future<List<UserModel>> getBlockedContacts() {
    return cacheContractor.getBlockedContacts();
  }

  @override
  Future<Stream<List<UserModel>>> getContactsStream() async {
    return cacheContractor.getContactsStream();
  }
}

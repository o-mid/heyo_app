import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

abstract class ContactRepo {
  Future<List<UserModel>> getContacts();

  Future<void> addContact(UserModel userModel);

  Future<List<UserModel>> search(String query);

  Future<void> deleteUserContact(UserModel user);

  Future<dynamic> deleteContactById(String userCoreId);

  Future<void> updateUserContact(UserModel user);

  Future<UserModel?> getContactById(String userCoreId);

  Future<List<UserModel>> getBlockedContacts();

  Future<Stream<List<UserModel>>> getContactsStream();
}

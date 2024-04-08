import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

abstract class ContactRepo {
  Future<List<ContactModel>> getContacts();

  Future<void> addContact(ContactModel contact);

  Future<List<ContactModel>> search(String query);

  Future<void> deleteUserContact(ContactModel contact);

  Future<dynamic> deleteContactById(String contactCoreId);

  Future<void> updateUserContact(ContactModel contact);

  Future<ContactModel?> getContactById(String contactCoreId);

  //Future<List<ContactModel>> getBlockedContacts();

  Future<Stream<List<ContactModel>>> getContactsStream();
}

import 'package:heyo/app/modules/shared/data/models/user_contact.dart';

abstract class CacheContractor {
  Future<List<UserContact>> getUserContacts();

  Future addUserContact(UserContact user);
}

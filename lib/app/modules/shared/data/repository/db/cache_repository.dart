import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_contact_dao.dart';

class CacheRepository extends CacheContractor {
  final UserContactProvider userContact;

  CacheRepository({required this.userContact});

  @override
  Future<List<UserContact>> getUserContacts() {
    return userContact.getAllSortedByName();
  }

  @override
  Future addUserContact(UserContact user) {
    return userContact.insert(user);
  }
}

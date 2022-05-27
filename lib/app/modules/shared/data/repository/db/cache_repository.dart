import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_contact_dao.dart';

class CacheRepository extends CacheContractor {
  final UserContactDao userContactDao;

  CacheRepository({required this.userContactDao});

  @override
  Future<List<UserContact>> getUserContacts() {
    return userContactDao.getAllSortedByName();
  }

  @override
  Future addUserContact(UserContact user) {
    return userContactDao.insert(user);
  }
}

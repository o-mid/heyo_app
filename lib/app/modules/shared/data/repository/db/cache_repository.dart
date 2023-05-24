import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';

import '../../../../new_chat/data/models/user_model.dart';

class CacheRepository extends CacheContractor {
  final UserProvider userContact;

  CacheRepository({required this.userContact});

  @override
  Future<List<UserModel>> getUserContacts() {
    return userContact.getAllSortedByName();
  }

  @override
  Future addUserContact(UserModel user) {
    return userContact.insert(user);
  }
}

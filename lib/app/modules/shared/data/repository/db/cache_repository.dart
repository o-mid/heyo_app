import 'package:heyo/app/modules/shared/data/repository/db/cache_contractor.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';

import '../../../../new_chat/data/models/user_model/user_model.dart';

class CacheRepository extends CacheContractor {
  final UserProvider userProvider;

  CacheRepository({required this.userProvider});

  @override
  Future<List<UserModel>> getUserContacts() {
    return userProvider.getAllSortedByName();
  }

  @override
  Future addUserContact(UserModel user) {
    return userProvider.insert(user);
  }

  @override
  Future deleteUserContact(UserModel user) async {
    return userProvider.delete(user);
  }

  @override
  Future updateUserContact(UserModel user) {
    return userProvider.update(user);
  }

  @override
  Future<List<UserModel>> getBlockedContacts() {
    return userProvider.getBlocked();
  }

  @override
  Future<UserModel?> getContactById(String userCoreId) {
    return userProvider.getContactById(userCoreId);
  }

  @override
  Future<Stream<List<UserModel>>> getContactsStream() async {
    return userProvider.getContactsStream();
  }

  @override
  Future<void> deleteContactById(String userCoreId) {
    return userProvider.deleteContactById(userCoreId);
  }
}

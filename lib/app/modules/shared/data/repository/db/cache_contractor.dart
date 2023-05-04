import 'package:heyo/app/modules/shared/data/models/user_contact.dart';

import '../../../../new_chat/data/models/user_model.dart';

abstract class CacheContractor {
  Future<List<UserModel>> getUserContacts();

  Future addUserContact(UserModel user);
}

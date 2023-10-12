import 'dart:async';

import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

import '../../../../new_chat/data/models/user_model/user_model.dart';

class UserProvider {
  final AppDatabaseProvider appDatabaseProvider;
  UserProvider({required this.appDatabaseProvider});
  static const String usersStoreName = 'users';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are User objects converted to Map
  final _userStore = intMapStoreFactory.store(usersStoreName);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await appDatabaseProvider.database;

  Future insert(UserModel user) async {
    await _userStore.add(
      await _db,
      user
          .copyWith(
            isContact: true,
          )
          .toJson(),
    );
  }

  Future update(UserModel user) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(user.coreId));
    await _userStore.update(
      await _db,
      user.toJson(),
      finder: finder,
    );
  }

  Future delete(UserModel user) async {
    final finder = Finder(filter: Filter.byKey(user.coreId));
    await _userStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<void> deleteContactById(String userCoreId) async {
    final finder = Finder(filter: Filter.equals('coreId', userCoreId));
    print("finder delete contact id: " + finder.toString());
    await _userStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<UserModel>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(
      sortOrders: [
        SortOrder('nickname'),
      ],
    );

    final records = await _userStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<User> out of List<RecordSnapshot>
    return records.map((e) => UserModel.fromJson(e.value)).toList();
  }

// get Blocked Contacts
  Future<List<UserModel>> getBlocked() async {
    final finder = Finder(filter: Filter.equals('isBlocked', true));

    final records = await _userStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<User> out of List<RecordSnapshot>
    return records.map((e) => UserModel.fromJson(e.value)).toList();
  }

  Future<UserModel?> getContactById(String userCoreId) async {
    final records = await _userStore.find(
      await _db,
      finder: Finder(filter: Filter.equals('coreId', userCoreId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final userJson = records.first.value;
    return UserModel.fromJson(userJson);
  }

  Future<Stream<List<UserModel>>> getContactsStream() async {
    final query = _userStore.query(
      finder: Finder(sortOrders: [SortOrder('nickname', false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data.map((e) => UserModel.fromJson(e.value)).toList());
        },
      ),
    );
  }
}

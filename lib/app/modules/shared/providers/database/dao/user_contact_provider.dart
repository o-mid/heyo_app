import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

class UserContactProvider {
  final AppDatabaseProvider appDatabaseProvider;
  UserContactProvider({required this.appDatabaseProvider});
  static const String userContactsStoreName = 'user_contacts';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are User objects converted to Map
  final _userStore = intMapStoreFactory.store(userContactsStoreName);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await appDatabaseProvider.database;

  Future insert(UserContact user) async {
    await _userStore.add(await _db, user.toJson());
  }

  Future update(UserContact user) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(user.coreId));
    await _userStore.update(
      await _db,
      user.toJson(),
      finder: finder,
    );
  }

  Future delete(UserContact user) async {
    final finder = Finder(filter: Filter.byKey(user.coreId));
    await _userStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<UserContact>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder(UserContact.nicknameSerializedName),
    ]);

    final records = await _userStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<User> out of List<RecordSnapshot>
    return records.map((e) => UserContact.fromJson(e.value)).toList();
  }
}

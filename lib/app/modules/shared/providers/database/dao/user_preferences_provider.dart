import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

import '../../../data/models/user_preferences.dart';

class UserPreferencesProvider {
  final AppDatabaseProvider appDatabaseProvider;
  UserPreferencesProvider({required this.appDatabaseProvider});
  static const String userPreferencesStoreName = 'user_preferences';

  // A Store with int keys and Map<String, dynamic> values.

  final _userStore = stringMapStoreFactory.store(userPreferencesStoreName);
  Future<Database> get _db async => await appDatabaseProvider.database;

  Future _insert(UserPreferences user) async {
    await _userStore.add(await _db, user.toJson());
  }

  // create UserPreferences if not exists or update the exiting one
  Future<void> createOrUpdateUserPreferences({required UserPreferences user}) async {
    final finder = Finder(filter: Filter.byKey(user.chatId));
    final record = await _userStore.findFirst(
      await _db,
      finder: finder,
    );
    if (record == null) {
      await _insert(user);
    } else {
      await _userStore.update(
        await _db,
        user.toJson(),
        finder: finder,
      );
    }
  }

  Future<void> updateUserPreferences({required UserPreferences user}) async {
    final finder = Finder(filter: Filter.byKey(user.chatId));
    await _userStore.update(
      await _db,
      user.toJson(),
      finder: finder,
    );
  }

  Future<void> deleteUserPreferences({required String chatId}) async {
    final finder = Finder(filter: Filter.byKey(chatId));
    await _userStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<UserPreferences?> getUserPreferences({required String chatId}) async {
    final finder = Finder(filter: Filter.byKey(chatId));
    final record = await _userStore.findFirst(
      await _db,
      finder: finder,
    );
    if (record == null) {
      return null;
    }
    return UserPreferences.fromJson(record.value);
  }

  Future<List<UserPreferences>> getAllUserPreferences() async {
    final records = await _userStore.find(
      await _db,
    );
    if (records.isEmpty) {
      return [];
    } else {
      return records.map((e) => UserPreferences.fromJson(e.value)).toList();
    }
  }
}

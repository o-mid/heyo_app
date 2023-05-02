// import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
// import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
// import 'package:heyo/app/modules/shared/providers/database/dao/user_preferences/user_preferences_abstract_provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:sembast/utils/value_utils.dart';

// import '../../../../data/models/user_preferences.dart';

// class UserPreferencesProvider implements UserPreferencesAbstractProvider {
//   final AppDatabaseProvider appDatabaseProvider;
//   UserPreferencesProvider({required this.appDatabaseProvider});
//   static const String userPreferencesStoreName = 'user_preferences';

//   // A Store with int keys and Map<String, dynamic> values.

//   final _userStore = stringMapStoreFactory.store(userPreferencesStoreName);
//   Future<Database> get _db async => await appDatabaseProvider.database;

//   Future _insert(UserPreferences user) async {
//     await _userStore.add(await _db, user.toJson());
//   }

//   // create UserPreferences if not exists or update the exiting one
//   @override
//   Future<void> createOrUpdateUserPreferences(UserPreferences user) async {
//     final finder = Finder(filter: Filter.equals(UserPreferences.chatIdSerializedName, user.chatId));
//     final record = await _userStore.findFirst(
//       await _db,
//       finder: finder,
//     );
//     if (record == null) {
//       await _insert(user);
//     } else {
//       await _userStore.update(
//         await _db,
//         user.toJson(),
//         finder: finder,
//       );
//     }
//   }

//   @override
//   Future<void> updateUserPreferences(UserPreferences user) async {
//     final finder = Finder(filter: Filter.equals(UserPreferences.chatIdSerializedName, user.chatId));
//     await _userStore.update(
//       await _db,
//       user.toJson(),
//       finder: finder,
//     );
//   }

//   @override
//   Future<void> deleteUserPreferences(String chatId) async {
//     final finder = Finder(filter: Filter.equals(UserPreferences.chatIdSerializedName, chatId));
//     await _userStore.delete(
//       await _db,
//       finder: finder,
//     );
//   }

//   @override
//   Future<UserPreferences?> getUserPreferencesById(String chatId) async {
//     final finder = Finder(filter: Filter.equals(UserPreferences.chatIdSerializedName, chatId));
//     final record = await _userStore.findFirst(
//       await _db,
//       finder: finder,
//     );
//     if (record == null) {
//       return null;
//     }
//     return UserPreferences.fromJson(record.value);
//   }

//   @override
//   Future<List<UserPreferences>> getAllUserPreferences() async {
//     final records = await _userStore.find(
//       await _db,
//     );
//     if (records.isEmpty) {
//       return [];
//     } else {
//       return records.map((e) => UserPreferences.fromJson(e.value)).toList();
//     }
//   }
// }

import 'package:heyo/app/modules/shared/data/models/user_preferences.dart';
import 'package:heyo/app/modules/shared/providers/database/repos/user_preferences/user_preferences_abstract_repo.dart';

import '../../dao/user_preferences/user_preferences_abstract_provider.dart';

class UserPreferencesRepo implements UserPreferencesAbstractRepo {
  final UserPreferencesAbstractProvider userPreferencesProvider;
  UserPreferencesRepo({required this.userPreferencesProvider});

  @override
  Future<void> createOrUpdateUserPreferences(UserPreferences userPreferences) {
    return userPreferencesProvider.createOrUpdateUserPreferences(userPreferences);
  }

  @override
  Future<UserPreferences?> getUserPreferencesById(String chatId) {
    return userPreferencesProvider.getUserPreferencesById(chatId);
  }

  @override
  Future<void> updateUserPreferences(UserPreferences userPreferences) {
    return userPreferencesProvider.updateUserPreferences(userPreferences);
  }

  @override
  Future<void> deleteUserPreferences(String chatId) {
    return userPreferencesProvider.deleteUserPreferences(chatId);
  }

  @override
  Future<List<UserPreferences>> getAllUserPreferences() {
    return userPreferencesProvider.getAllUserPreferences();
  }
}

import '../../../../data/models/user_preferences.dart';

abstract class UserPreferencesAbstractRepo {
  Future<void> createOrUpdateUserPreferences(UserPreferences userPreferences);

  Future<UserPreferences?> getUserPreferencesById(String chatId);

  Future<void> updateUserPreferences(UserPreferences userPreferences);

  Future<void> deleteUserPreferences(String chatId);

  Future<List<UserPreferences>> getAllUserPreferences();
}

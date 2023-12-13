abstract class LocalStorageAbstractProvider {
  Future<bool> saveToStorage(String key, String value);

  Future<bool> isAvailableInStorage(String key);

  Future<String?> readFromStorage(String key);

  Future<bool> deleteFromStorage(String key);
}

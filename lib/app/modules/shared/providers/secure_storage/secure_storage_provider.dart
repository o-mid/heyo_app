import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';

class SecureStorageProvider implements LocalStorageAbstractProvider {
  // Create storage
  final storage = const FlutterSecureStorage();
  Future<bool> saveToStorage(String key, String value) async {
    await storage.write(key: key, value: value);
    return true;
  }

  Future<bool> isAvailableInStorage(String key) async {
    String? value = await storage.read(key: key);
    return value != null;
  }

  Future<String?> readFromStorage(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future<bool> deleteFromStorage(String key) async {
    await storage.delete(key: key);

    return true;
  }
}

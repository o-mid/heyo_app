import 'package:flutter/foundation.dart';

abstract class SplashAbstractRepository {
  Future<bool> fetchAllRegistries();
  Future<void> removeStorageOnFirstRun();
}

import 'package:flutter/foundation.dart';

abstract class SplashAbstractRepository {
  Future<void> removeStorageOnFirstRun();
}

import 'package:flutter/foundation.dart';

abstract class SplashAbstractRepository {
  Future<bool> sendFCMToken();
  Future<bool> fetchAllRegistries();
}

import 'package:tuple/tuple.dart';

abstract class IntroAbstractRepo {
  /// returning status by a bool identifier, and results
  Future<Tuple3<bool, String, String>> retrieveCoreIdFromCorePass();

  bool launchStore();

  Future<bool> applyDelegatedCredentials(String coreId,String signature);
}

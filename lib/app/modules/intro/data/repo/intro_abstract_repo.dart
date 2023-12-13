import 'package:tuple/tuple.dart';

abstract class IntroAbstractRepo {

  Future<void> initConnectionContractor();

  /// returning status by a bool identifier, and results
  Future<Tuple3<bool, String, String>> retrieveCoreIdFromCorePass();

  bool launchStore();

  Future<bool> applyDelegatedCredentials(String coreId,String signature);
}

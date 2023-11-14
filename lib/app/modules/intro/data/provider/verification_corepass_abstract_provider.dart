import 'package:tuple/tuple.dart';

abstract class VerificationCorePassAbstractProvider {
  Future<bool> launchVerificationProcess();

  Future<Tuple2<String, String>> listenForResponse();

  Future<bool> setCredentials(String coreId, String signature);

  Future<void> cleanUp();
}

import 'package:tuple/tuple.dart';

abstract class VerificationCorePassAbstractProvider {
  Future<bool> launchVerificationProcess();

  Future<Tuple2<String, String>> listenForResponse();

  Future<bool> applyDelegatedCredentials(String coreId, String signature);
  void setDelegationStatus({required bool status});

  Future<void> cleanUp();
}

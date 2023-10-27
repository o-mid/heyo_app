import 'dart:async';

abstract class ConnectionContractor {

  void init(dynamic data);

  Stream<String> getMessageStream();

  Future<void> sendMessage(String data, dynamic remoteId);
}

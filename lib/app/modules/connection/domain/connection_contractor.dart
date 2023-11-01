import 'dart:async';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

abstract class ConnectionContractor {

  void init();

  Stream<ConnectionRequestReceived> getMessageStream();

  Future<bool> sendMessage(String data, dynamic remote);
}

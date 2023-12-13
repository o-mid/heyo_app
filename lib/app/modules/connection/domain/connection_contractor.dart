import 'dart:async';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

abstract class ConnectionContractor {

  Future<void> init();
  void start();

  Stream<ConnectionRequestReceived> getMessageStream();

  Future<bool> sendMessage(String data, dynamic remote);
}

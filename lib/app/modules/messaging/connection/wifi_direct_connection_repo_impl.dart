import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';

import '../multiple_connections.dart';
import 'connection_repo.dart';

class WiFiDirectConnectionRepoImpl extends ConnectionRepo {
  WiFiDirectConnectionRepoImpl({
    required super.dataHandler, // New argument
  });
  // ... fields specific to RTC
  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    // ... implement RTC logic
  }
  @override
  Future<void> initConnection({MultipleConnectionHandler? multipleConnectionHandler}) async {}
}

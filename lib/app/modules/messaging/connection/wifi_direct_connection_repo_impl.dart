import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';

import '../multiple_connections.dart';
import 'connection_repo.dart';

class WiFiDirectConnectionRepoImpl extends ConnectionRepo {
  WiFiDirectConnectionRepoImpl({
    required super.dataHandler, // New argument
  });
  // ... fields specific to RTC
  @override
  Future<void> initMessagingConnection(
      {required String remoteId, MultipleConnectionHandler? multipleConnectionHandler}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
// TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteCoreId): sendTextMessage($text)');

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    _heyoWifiDirect!
        .sendMessage(HeyoWifiDirectMessage(receiverId: remoteCoreId!, isBinary: false, body: text));
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    // TODO remove debug output

    DataBinaryMessage sendingMessage = DataBinaryMessage.parse(binary);

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    // TODO implement binary sending
    print(
      'WifiDirectConnectionController(remoteId $remoteCoreId): sendBinaryData() header ${sendingMessage.header.toString()}',
    );

    _heyoWifiDirect!.sendBinaryData(
      receiver: remoteCoreId,
      header: sendingMessage.header,
      chunk: sendingMessage.chunk,
    );
  }

  @override
  Future<void> initConnection({MultipleConnectionHandler? multipleConnectionHandler}) async {}
}

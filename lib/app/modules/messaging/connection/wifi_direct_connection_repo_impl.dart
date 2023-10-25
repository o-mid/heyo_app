import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../multiple_connections.dart';
import 'connection_repo.dart';

class WiFiDirectConnectionRepoImpl extends ConnectionRepo {
  WiFiDirectConnectionRepoImpl({
    required super.dataHandler, // New argument
  });
  WifiDirectWrapper? wifiDirectWrapper;
  HeyoWifiDirect? _heyoWifiDirect;
  String? remoteId;
  @override
  Future<void> initMessagingConnection(
      {required String remoteId, MultipleConnectionHandler? multipleConnectionHandler}) async {
    if (this.remoteId == remoteId) {
      // TODO remove debug output
      print(
        'WifiDirectConnectionController(remoteId $remoteId): initMessagingConnection -> already connected',
      );
      return;
    }

    _initWiFiDirect();

    // TODO remove debug output
    print(
      'WifiDirectConnectionController: initMessagingConnection($remoteId), status ${(_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status.name}',
    );
    this.remoteId = remoteId;

    switch ((_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status) {
      case PeerStatus.peerTCPOpened:
        connectivityStatus.value = ConnectivityStatus.justConnected;
      case PeerStatus.peerConnected:
        connectivityStatus.value = ConnectivityStatus.justConnected;
      default:
        connectivityStatus.value = ConnectivityStatus.connectionLost;
        break;
    }
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
  Future<void> initConnection({
    MultipleConnectionHandler? multipleConnectionHandler,
    WifiDirectWrapper? wifiDirectWrapper,
  }) async {
    this.wifiDirectWrapper = wifiDirectWrapper;
  }

  void _initWiFiDirect() {
    _heyoWifiDirect = wifiDirectWrapper!.pluginInstance;
    if (_heyoWifiDirect == null) {
      print(
        "HeyoWifiDirect plugin not initialized! Wi-Fi Direct functionality may not be available",
      );
    }
  }
}

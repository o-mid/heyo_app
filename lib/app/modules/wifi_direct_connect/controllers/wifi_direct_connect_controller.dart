import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/connection/wifi_direct_connection_provider.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../messages/connection/wifi_direct_connection_controller.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

class WifiDirectConnectController extends GetxController {
  //TODO: Implement WifiDirectConnectController

  late WifiDirectConnectionProvider wifiDirectConnectionProvider;
  late HeyoWifiDirect _pluginInstance;
  late StreamSubscription _eventListener;
  late UserModel user;

  /* WifiDirectConnectController({required this.wifiDirectConnectionController,required this.wifiDirectConnectionProvider}) {
    //_pluginInstance = wifiDirectConnectionController.wifiDirectWrapper!.pluginInstance!;
  }*/

  Rx<PeerStatus> connectionStatus = PeerStatus.statusUnknown.obs;

  @override
  void onInit() {
    super.onInit();

    /* _eventListener = wifiDirectConnectionController
        .wifiDirectWrapper!.pluginInstance!.consumerEventSource.stream
        .listen((event) => eventHandler(event));
    user = Get.arguments as UserModel;*/
  }

  Future<bool> startConnection() async {
    if (_pluginInstance.peerList.contains(user.coreId)) {
      _pluginInstance.connectPeer(user.coreId);
    } else {
      return false;
    }

    return true;
  }

  void eventHandler(WifiDirectEvent event) {
    print('WifiDirectConnectController: WifiDirect event: ${event.type}, ${event.dateTime}');

    switch (event.type) {
      // Refresh information about wifi-direct available peers
      case EventType.peerListRefresh:

        // PeerList peerList = signaling.wifiDirectPlugin.peerList;
        if (_pluginInstance.peerList.contains(user.coreId)) {
          connectionStatus.value = (_pluginInstance.peerList.peers[user.coreId] as Peer)!.status;
        } else {
          connectionStatus.value = PeerStatus.peerUnavailable;
        }

        print('WifiDirectConnectController: connectionStatus ${connectionStatus.value.name}');

        break;

      case EventType.linkedPeer:
        // incomingConnection = true.obs;
        // connectedPeer = event.message as Peer;
        //   wifiDirectConnectionController.eventHandler(event);
        connectionStatus.value =
            (_pluginInstance.peerList.peers[user.coreId] as Peer).status as PeerStatus;

        print('WifiDirectConnectController: linked to ${(event.message as Peer).multiAddress}');

        break;

      case EventType.groupStopped:
        // incomingConnection = false.obs;
        // outgoingConnection = false.obs;
        // connectedPeer = null;
        //   wifiDirectConnectionController.eventHandler(event);

        print('WifiDirectConnectController: Wifi-direct group stopped');
        break;

      default:
        break;
    }

    //==========================================

    switch (connectionStatus.value) {
      case PeerStatus.peerConnected:
        print('WifiDirectConnectView peer Connected ${user.coreId}');

        Future.delayed(const Duration(milliseconds: 500), () {
          Get
            ..back()
            ..toNamed(
              Routes.MESSAGES,
              arguments: MessagesViewArgumentsModel(
                connectionType: MessagingConnectionType.wifiDirect,
                participants: [
                  MessagingParticipantModel(
                    coreId: user.coreId,
                    chatId: user.coreId,
                  ),
                ],
              ),
            );
        });
        break;

      case PeerStatus.peerTCPOpened:
        print('WifiDirectConnectView peer TCPOpened ${user.coreId}');

        Future.delayed(const Duration(milliseconds: 500), () {
          Get
            ..back()
            ..toNamed(
              Routes.MESSAGES,
              arguments: MessagesViewArgumentsModel(
                connectionType: MessagingConnectionType.wifiDirect,
                participants: [
                  MessagingParticipantModel(
                    coreId: user.coreId,
                    chatId: user.coreId,
                  ),
                ],
              ),
            );
        });
        break;

      case PeerStatus.peerUnavailable:
        Future.delayed(const Duration(milliseconds: 500), Get.back);
        break;

      default:
        break;
    }
    //==========================================
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _eventListener.cancel();
    super.onClose();
  }
}

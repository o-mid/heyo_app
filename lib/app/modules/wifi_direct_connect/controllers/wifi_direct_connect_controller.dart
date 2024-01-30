import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/connection/wifi_direct_connection_provider.dart';
import 'package:heyo/app/modules/messages/views/messages_view.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../messages/connection/wifi_direct_connection_controller.dart';
import '../../messages/utils/chat_Id_generator.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';

class WifiDirectConnectController extends GetxController {
  //TODO: Implement WifiDirectConnectController

  late WifiDirectConnectionProvider wifiDirectConnectionProvider;
  late HeyoWifiDirect _pluginInstance;
  late StreamSubscription _eventListener;

  late MessagesViewArgumentsModel args;
  late String coreId;
  late String chatId;

  WifiDirectConnectController() {
    _pluginInstance = WifiDirectWrapper.pluginInstance!;
  }

  Rx<PeerStatus> connectionStatus = PeerStatus.statusUnknown.obs;

  @override
  void onInit() {
    super.onInit();

    _eventListener = WifiDirectWrapper.pluginInstance!.consumerEventSource.stream
        .listen((event) => eventHandler(event));
    args = Get.arguments as MessagesViewArgumentsModel;
    coreId = args.participants.first.coreId;
    chatId = args.participants.first.chatId;
  }

  Future<bool> startConnection() async {
    if (_pluginInstance.peerList.contains(coreId)) {
      await _pluginInstance.connectPeer(coreId);
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
        if (_pluginInstance.peerList.contains(coreId)) {
          connectionStatus.value = (_pluginInstance.peerList.peers[coreId]!).status;
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
            (_pluginInstance.peerList.peers[coreId] as Peer).status as PeerStatus;

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
        print('WifiDirectConnectView peer Connected ${coreId}');

        Future.delayed(const Duration(milliseconds: 500), () {
          Get
            ..back()
            ..toNamed(
              Routes.MESSAGES,
              arguments: MessagesViewArgumentsModel(
                connectionType: MessagingConnectionType.wifiDirect,
                participants: [
                  MessagingParticipantModel(
                    coreId: coreId,
                    chatId: chatId,
                  ),
                ],
              ),
            );
        });
        break;

      case PeerStatus.peerTCPOpened:
        print('WifiDirectConnectView peer TCPOpened ${coreId}');

        Future.delayed(const Duration(milliseconds: 500), () {
          Get
            ..back()
            ..toNamed(
              Routes.MESSAGES,
              arguments: MessagesViewArgumentsModel(
                connectionType: MessagingConnectionType.wifiDirect,
                participants: [
                  MessagingParticipantModel(
                    coreId: coreId,
                    chatId: chatId,
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

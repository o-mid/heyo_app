import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

class WifiDirectConnectionProvider{



  void handleWifiDirectEvents(WifiDirectEvent event,String remoteId) {
  /*  print('WifiDirectConnectionController(remoteId $remoteId): WifiDirect event: ${event.type}');
    switch (event.type) {
      case EventType.linkedPeer:
        remoteId = (event.message as Peer).coreID;
        _startIncomingWiFiDirectMessaging();
      case EventType.groupStopped:
        remoteId = null;
        handleWifiDirectConnectionClose();
      default:
        break;
    }*/
  }
  _startIncomingWiFiDirectMessaging() async {
/*    ChatModel? userChatModel;

    await dataHandler.chatHistoryRepo.getChat(remoteId!).then((value) {
      userChatModel = value;
    });

    _initWiFiDirect();

    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
        // session: session,

        coreId: remoteId!,
        iconUrl: userChatModel?.icon,
        connectionType: MessagingConnectionType.wifiDirect,
      ),
    );
    connectivityStatus.value = ConnectivityStatus.justConnected;
    setConnectivityOnline();*/
  }


  handleWifiDirectConnectionClose() {
  /*  if (Get.currentRoute == Routes.MESSAGES) {
      Get.until((route) => Get.currentRoute != Routes.MESSAGES);
    }*/
  }
}
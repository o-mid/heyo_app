import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../chats/data/models/chat_model.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

class MessagingConnectionController extends GetxController {
  final Messaging messaging;
  final AccountInfo accountInfo;
  bool isConnectionConnected = false;
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  MessagingConnectionController({required this.messaging, required this.accountInfo});
  RTCDataChannel? _dataChannel;
  @override
  void onInit() {
    init();
  }

  init() async {
    messaging.onDataChannel = (_, channel) {
      _dataChannel = channel;
    };
    observeMessagingStatus();
  }

  void observeMessagingStatus() {
    messaging.onMessageStateChange = (session, status) async {
      connectionStatus.value = status;

      print("Connection Status changed, state is: $status");

      if (status == ConnectionStatus.RINGING) {
        Get.toNamed(
          Routes.MESSAGES,
          arguments: MessagesViewArgumentsModel(
            session: session,

            // Todo Omid :
            chat: ChatModel(
                icon: "",
                id: session.cid,
                lastMessage: "",
                name: "",
                timestamp: DateTime.now(),
                isOnline: true,
                isVerified: true,
                notificationCount: 0),
          ),
        );
      } else if (status == ConnectionStatus.BYE) {
        //    Get.snackbar("ConnectionLost", "ConnectionLost");
        if (Get.currentRoute == Routes.MESSAGES) {
          Get.until((route) => Get.currentRoute != Routes.MESSAGES);
        }
      }
      if (status == ConnectionStatus.CONNECTED) {
        isConnectionConnected = true;
      }
    };
  }

  Future<MessageSession> startMessaging(
    String remoteId,
    String callId,
  ) async {
    String? selfCoreId = await accountInfo.getCoreId();
    return await messaging.connectionRequest(remoteId, 'video', false, selfCoreId!);
  }

  void sendTextMessage(String text) async {
    await _dataChannel?.send(RTCDataChannelMessage(text));
  }

  void sendBinaryMessage(Uint8List binary) async {
    await _dataChannel?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  MessageSession? getSession(String coreId) {
    return messaging.getSessions()[coreId];
  }

  Future acceptMessageConnection(MessageSession session) async {
    messaging.accept(
      session.sid,
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../chats/data/models/chat_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

class MessagingConnectionController extends GetxController {
  final Messaging messaging;
  final MessagesAbstractRepo messagesRepo;
  final AccountInfo accountInfo;
  bool isConnectionConnected = false;
  final JsonDecoder _decoder = const JsonDecoder();
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  MessagingConnectionController(
      {required this.messaging, required this.accountInfo, required this.messagesRepo});
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
        await acceptMessageConnection(session);
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
        messaging.onDataChannelMessage = (_, dc, RTCDataChannelMessage data) {
          String text = data.text;
          // print(text);
          Map<String, dynamic> json = _decoder.convert(text);

          //  MessageModel? message = messageFromJson(json);
          TextMessageModel message = TextMessageModel.fromJson(json);
          print(message);

          messagesRepo.createMessage(message: message, chatId: session.cid);
          messagesRepo.getMessages(session.cid).asStream().listen((event) {
            print(event);
          });

//messagesRepo.createMessage(message: message, chatId: chatId)

          // var receivedMessage = TextMessageModel(
          //   // Todo: Generate random id
          //   messageId: messages.length.toString(),
          //   text: data.text,ß
          //   timestamp: DateTime.now().toUtc(),
          //   replyTo: replyingTo.value,
          //   // Todo: fill with user info
          //   senderName: "",
          //   senderAvatar: "",
          //   isFromMe: false,
          // );
          // messages.add(receivedMessage);
          // messages.refresh();
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   jumpToBottom();
          // });
        };
      }
    };
  }

  Future<MessageSession> startMessaging(
    String remoteId,
    String callId,
  ) async {
    String? selfCoreId = await accountInfo.getCoreId();
    return await messaging.connectionRequest(remoteId, 'data', false, selfCoreId!);
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

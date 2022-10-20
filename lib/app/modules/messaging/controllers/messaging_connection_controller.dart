import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../chats/data/models/chat_model.dart';
import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../models/data_channel_message_model.dart';

class MessagingConnectionController extends GetxController {
  final Messaging messaging;
  final MessagesAbstractRepo messagesRepo;
  final ChatHistoryAbstractRepo chatHistoryRepo;
  final AccountInfo accountInfo;
  bool isConnectionConnected = false;
  final JsonDecoder _decoder = const JsonDecoder();
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  MessagingConnectionController(
      {required this.messaging,
      required this.accountInfo,
      required this.messagesRepo,
      required this.chatHistoryRepo});
  late RTCDataChannel _dataChannel;
  @override
  void onInit() {
    super.onInit();
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
        ChatModel userChatModel = ChatModel(
            id: session.cid,
            isOnline: true,
            name:
                "${session.cid.characters.take(4).string}...${session.cid.characters.takeLast(4).string}",
            icon: ([
              "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
              "https://avatars.githubusercontent.com/u/6634136?v=4",
              "https://avatars.githubusercontent.com/u/9801359?v=4",
            ]..shuffle())
                .first,
            lastMessage: "",
            isVerified: true,
            timestamp: DateTime.now());

        chatHistoryRepo.addChatToHistory(userChatModel);

        Get.toNamed(
          Routes.MESSAGES,
          arguments: MessagesViewArgumentsModel(
            session: session,
            user: UserModel(
              icon: userChatModel.icon,
              name: userChatModel.name,
              walletAddress: session.cid,
              isOnline: userChatModel.isOnline,
              chatModel: userChatModel,
            ),
          ),
        );
      } else if (status == ConnectionStatus.CONNECTED) {
        isConnectionConnected = true;
        print("Connection Status changed, state is: $status");

        channelMessageListener();
      } else if (status == ConnectionStatus.BYE) {
        if (Get.currentRoute == Routes.MESSAGES) {
          Get.until((route) => Get.currentRoute != Routes.MESSAGES);
        }
      }
    };
  }

  channelMessageListener() {
    messaging.onDataChannelMessage = (session, dc, RTCDataChannelMessage data) async {
      if (data.isBinary == false) {
        String text = data.text;
        Map<String, dynamic> json = _decoder.convert(text);
        DataChannelMessageModel channelMessage = DataChannelMessageModel.fromJson(json);
        print(channelMessage);
        if (channelMessage.dataChannelMessagetype == DataChannelMessageType.message) {
          MessageModel? message = messageFromJson(channelMessage.message);
          print(message);
          if (message != null) {
            if (message.type == MessageContentType.image) {
              message = (message as ImageMessageModel).copyWith(isLocal: false);
            }
            await messagesRepo.createMessage(
                message: message.copyWith(
                  isFromMe: false,
                ),
                chatId: session.cid);
          }
        }
      }
    };
  }

  Future<void> startMessaging(
    String remoteId,
  ) async {
    String? selfCoreId = await accountInfo.getCoreId();

    MessageSession session =
        await messaging.connectionRequest(remoteId, 'data', false, selfCoreId!);
    ChatModel userChatModel = ChatModel(
        id: session.cid,
        name:
            "${session.cid.characters.take(4).string}...${session.cid.characters.takeLast(4).string}",
        icon: ([
          "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
          "https://avatars.githubusercontent.com/u/6634136?v=4",
          "https://avatars.githubusercontent.com/u/9801359?v=4",
        ]..shuffle())
            .first,
        lastMessage: "",
        isOnline: true,
        isVerified: true,
        timestamp: DateTime.now());
    chatHistoryRepo.addChatToHistory(userChatModel);
  }

  void sendTextMessage(String text) async {
    await _dataChannel.send(RTCDataChannelMessage(text));
  }

  void sendBinaryMessage(Uint8List binary) async {
    await _dataChannel.send(RTCDataChannelMessage.fromBinary(binary));
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

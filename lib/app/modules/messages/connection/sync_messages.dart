// ignore_for_file: require_trailing_commas

import 'package:get/get.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/messages/utils/message_to_send_message_type.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_history_model.dart';

import 'multiple_connections.dart';

class SyncMessages {
  SyncMessages({
    required this.p2pState,
    required this.multipleConnectionHandler,
    required this.accountInfo,
    required this.chatHistoryRepo,
    required this.messagesRepo,
    required this.sendMessageUseCase,
  }) {
    _init();
  }

  final P2PState p2pState;
  final MultipleConnectionHandler multipleConnectionHandler;
  final AccountRepository accountInfo;
  final ChatHistoryRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;
  final SendMessageUseCase sendMessageUseCase;

  _init() async {
    _initiateConnections();

    _sendUnsentMessages();
  }

  void _sendUnsentMessages() {
    multipleConnectionHandler.onRTCSessionConnected = (rtcSession) async {
      print("syncMessages: onRTCSessionConnected: ${rtcSession.connectionId} ");
      await Future.delayed(Duration(seconds: 5));
      List<ChatHistoryModel> userChats =
          await chatHistoryRepo.getChatsFromUserId(rtcSession.remotePeer.remoteCoreId);

      for (final chat in userChats) {
        final chatId = chat.id;

        final List<MessageModel?> unsentMessages = await messagesRepo.getUnsentMessages(chatId);

        print("syncMessages: size : ${unsentMessages.length} ");

        for (var message in unsentMessages) {
          print("syncMessages: message: ${rtcSession.connectionId} ");

          if (message != null) {
            print("syncMessages: sendMessageType: ${rtcSession.connectionId} ");

            SendMessageType? sendMessageType = message.getSendMessageType(chatId);
            if (sendMessageType != null) {
              print("syncMessages: execute: ${rtcSession.connectionId} ");

              await sendMessageUseCase.execute(
                  messageConnectionType: MessageConnectionType.RTC_DATA_CHANNEL,
                  sendMessageType: sendMessageType,
                  chatName: '',
                  remoteCoreIds: chat.participants.map((e) => e.coreId).toList(),
                  isUpdate: true,
                  messageModel: message);
              print(
                  "syncMessages: Message sent: $sendMessageType : ${chat.participants.toList()} ");
            }
          }
        }
      }
    };
  }

  void _initiateConnections() async {
    p2pState.advertise.listen((advertised) async {
      if (advertised) {
        for (final value in await chatHistoryRepo.getAllChats()) {
          print('syncMessages : _initiateConnections : getConnection');
          for (final element in value.participants) {
            multipleConnectionHandler.getConnection(element.coreId);
          }
        }
      }
    });
    //  wait until getting advertised
    // await p2pState.advertise
    //     .waitForResult(condition: (advertise) => advertise == true);
    // //
    // await p2pState.delegationSuccessful
    //     .waitForResult(condition: (value) => value);
    //
    // final selfCoreId = (await accountInfo.getCorePassCoreId())!;
    // multipleConnectionHandler.reset();
    // for (var value in await chatHistoryRepo.getAllChats()) {
    //   print('syncMessages : _initiateConnections : getConnection');
    //
    //   multipleConnectionHandler.initiateConnections(value.id, selfCoreId);
    // }
  }
}

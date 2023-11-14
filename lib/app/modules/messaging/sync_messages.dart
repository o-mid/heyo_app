import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/messages/utils/message_to_send_message_type.dart';
import 'package:heyo/app/modules/shared/utils/extensions/getx.extension.dart';

class SyncMessages {
  final P2PState p2pState;
  final MultipleConnectionHandler multipleConnectionHandler;
  final AccountInfo accountInfo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;
  final SendMessageUseCase sendMessageUseCase;

  SyncMessages(
      {required this.p2pState,
      required this.multipleConnectionHandler,
      required this.accountInfo,
      required this.chatHistoryRepo,
      required this.messagesRepo,
      required this.sendMessageUseCase}) {
    _init();
  }

  _init() async {
    _initiateConnections();

    _sendUnsentMessages();
  }

  _sendUnsentMessages() {
    multipleConnectionHandler.onRTCSessionConnected = (rtcSession) async {
      print("syncMessages: onRTCSessionConnected: ${rtcSession.connectionId} ");
      List<MessageModel?> unsentMessages =
          (await messagesRepo.getUnsentMessages(rtcSession.remotePeer.remoteCoreId));
      print("syncMessages: size : ${unsentMessages.length} ");

      for (var message in unsentMessages) {
        print("syncMessages: message: ${rtcSession.connectionId} ");

        if (message != null) {
          print("syncMessages: sendMessageType: ${rtcSession.connectionId} ");

          SendMessageType? sendMessageType =
              message.getSendMessageType(rtcSession.remotePeer.remoteCoreId);
          if (sendMessageType != null) {
            print("syncMessages: execute: ${rtcSession.connectionId} ");

            await sendMessageUseCase.execute(
              messageConnectionType: MessageConnectionType.RTC_DATA_CHANNEL,
                sendMessageType: sendMessageType,
                remoteCoreId: rtcSession.remotePeer.remoteCoreId,
                isUpdate: true,
                messageModel: message);
            print("syncMessages: Message sent ");
          }
        }
      }
    };
  }

  _initiateConnections() async {
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

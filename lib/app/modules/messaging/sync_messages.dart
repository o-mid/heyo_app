import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class SyncMessages {
  final P2PState p2pState;
  final MultipleConnectionHandler multipleConnectionHandler;
  final AccountInfo accountInfo;
  final ContactRepository contactRepository;
  final ChatHistoryLocalAbstractRepo chatHistoryLocalAbstractRepo;
  final MessagesAbstractRepo messagesAbstractRepo;
  SyncMessages(
      {required this.p2pState,
      required this.multipleConnectionHandler,
      required this.accountInfo,
      required this.contactRepository,
      required this.chatHistoryLocalAbstractRepo,
      required this.messagesAbstractRepo});

  init() async {

    p2pState.advertise.listen((advertise) async{
      if(advertise){

        String selfCoreId = (await accountInfo.getCoreId())!;

        multipleConnectionHandler.onRTCSessionConnected=(rtcSession) async{
          ( await messagesAbstractRepo.getUnReadMessages(rtcSession.remotePeer.remoteCoreId));

        };

        for (var value in (await chatHistoryLocalAbstractRepo.getAllChats())) {
          multipleConnectionHandler.getConnection(value.coreId, selfCoreId);
        }


      }
    });




  }
}

import 'package:get/get.dart';
import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/home/controllers/calls_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:heyo/app/modules/web-rtc/signaling.dart';

class GlobalBindings extends Bindings {
  static P2PState p2pState = P2PState();
  static Signaling signaling = Signaling(login: login);
  static Messaging messaging = Messaging(login: login);
  static P2PNodeResponseStream p2pNodeResponseStream = P2PNodeResponseStream(p2pState: p2pState);
  final P2PNodeRequestStream p2pNodeRequestStream =
      P2PNodeRequestStream(p2pState: p2pState, signaling: signaling, messaging: messaging);
  static Web3Client web3Client =
      Web3Client('https://stg.pingextest.eu/eth', http.Client(), 'ping-dev', 'caC12cas');

  static AccountInfo accountInfo = AccountRepo(
    localProvider: SecureStorageProvider(),
    cryptographyKeyGenerator: Web3Keys(web3client: web3Client),
  );
  static Login login = Login(
    p2pState: p2pState,
    accountInfo: accountInfo,
  );
  static CallConnectionController callConnectionController = CallConnectionController(
    accountInfo: accountInfo,
    signaling: signaling,
  );

  @override
  void dependencies() {
    Get.put(AppDatabaseProvider(accountInfo: accountInfo), permanent: true);
    Get.put(
      CallHistoryObserver(
        callHistoryRepo: CallHistoryRepo(
          callHistoryProvider:
              CallHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
        callConnectionController: callConnectionController,
      ),
    );
    Get.put(callConnectionController, permanent: true);
    Get.put(ChatsController());
    //also this
    Get.put(
      CallsController(
        callHistoryRepo: CallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
            appDatabaseProvider: Get.find<AppDatabaseProvider>(),
          ),
        ),
      ),
    );
    Get.put(AccountController(accountInfo: accountInfo));
    Get.put(GlobalMessageController());
    Get.put(AudioMessageController());
    Get.put(VideoMessageController());
    Get.put(LiveLocationController());
    Get.put(ConnectionController(p2pState: p2pState));

    Get.put<P2PNodeController>(
      P2PNodeController(
        p2pNode: P2PNode(
          accountInfo: accountInfo,
          p2pNodeRequestStream: p2pNodeRequestStream,
          p2pNodeResponseStream: p2pNodeResponseStream,
          p2pState: p2pState,
          web3client: web3Client,
        ),
      ),
      permanent: true,
    );
  }
}

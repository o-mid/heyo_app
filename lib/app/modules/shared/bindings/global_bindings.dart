import 'package:get/get.dart';
import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/home/controllers/calls_controller.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_abstract_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/web-rtc/web-rtc-connection.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class GlobalBindings extends Bindings {
  static P2PState p2pState = P2PState();
  static P2PNodeResponseStream p2pNodeResponseStream = P2PNodeResponseStream(p2pState: p2pState);
  final P2PNodeRequestStream p2pNodeRequestStream = P2PNodeRequestStream(p2pState: p2pState);
  static Web3Client web3Client =
      Web3Client('https://stg.pingextest.eu/eth', http.Client(), 'ping-dev', 'caC12cas');

  static AccountAbstractRepo accountInfo = AccountRepo(
    localProvider: SecureStorageProvider(),
    cryptographyKeyGenerator: Web3Keys(web3client: web3Client),
  );
  static Login login = Login(
    p2pState: p2pState,
    accountInfo: accountInfo,
  );
  static WebRTCConnection webRTCConnection = WebRTCConnection();
  static CallConnectionController callConnectionController = CallConnectionController(
    webRTCConnection: webRTCConnection,
    login: login,
    p2pState: p2pState,
  );

  @override
  void dependencies() {
    Get.put(callConnectionController);
    Get.put(ChatsController());
    Get.put(CallsController());
    Get.put(AccountController());
    Get.put(GlobalMessageController());
    Get.put(AudioMessageController());
    Get.put(VideoMessageController());
    Get.put(LiveLocationController());

    Get.put<P2PNodeController>(
      P2PNodeController(
        p2pNode: P2PNode(
            accountInfo: accountInfo,
            p2pNodeRequestStream: p2pNodeRequestStream,
            p2pNodeResponseStream: p2pNodeResponseStream,
            p2pState: p2pState,
            web3client: web3Client),
      ),
      permanent: true,
    );
  }
}

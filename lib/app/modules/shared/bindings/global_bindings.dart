import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/information/get_share_info.dart';
import 'package:heyo/app/modules/information/shareable_qr_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/data/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/data/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_manager.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/website-interact/website_interact_controller.dart';

class GlobalBindings extends Bindings {
  static P2PState p2pState = P2PState();
  final P2PNodeResponseStream p2pNodeResponseStream = P2PNodeResponseStream(p2pState: p2pState);
  final AccountInfo accountInfo =
      AccountManager(localProvider: SecureStorageProvider(), cryptographyKeyGenerator: Web3Keys());

  @override
  void dependencies() {
    Get.put(ChatsController());
    Get.put(GlobalMessageController());
    Get.put(AudioMessageController());
    Get.put(VideoMessageController());
    Get.put(LiveLocationController());
    Get.put<Login>(
      Login(
        p2pNodeResponseStream: p2pNodeResponseStream,
        p2pState: p2pState,
        accountInfo: accountInfo,
      ),
    );

    Get.put(WebsiteInteractController());

    Get.put<P2PNodeManager>(
      P2PNodeManager(
        p2pNode: P2PNode(
            accountInfo: accountInfo,
            p2pNodeRequestStream: P2PNodeRequestStream(),
            p2pNodeResponseStream: p2pNodeResponseStream,
            p2pState: p2pState),
      ),
      permanent: true,
    );

    Get.put(QRInfo(p2pState: p2pState, accountInfo: accountInfo));
    Get.put(ShareableQRController());
  }
}

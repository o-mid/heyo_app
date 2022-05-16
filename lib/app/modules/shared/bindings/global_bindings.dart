import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_manager.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

class GlobalBindings extends Bindings {
  static P2PState p2pState = P2PState();
  final P2PNodeResponseStream p2pNodeResponseStream =
      P2PNodeResponseStream(p2pState: p2pState);

  @override
  void dependencies() {
    Get.put(ChatsController());
    Get.put<Login>(Login(
        p2pNodeResponseStream: p2pNodeResponseStream, p2pState: p2pState));
    Get.put<P2PNodeManager>(
        P2PNodeManager(
            p2pNode: P2PNode(
                accountInfo: AccountManager(
                    localProvider: SecureStorageProvider(),
                    cryptographyKeyGenerator: Web3Keys()),
                p2pNodeRequestStream: P2PNodeRequestStream(),
                p2pNodeResponseStream: p2pNodeResponseStream,
                p2pState: p2pState)),
        permanent: true);
  }
}

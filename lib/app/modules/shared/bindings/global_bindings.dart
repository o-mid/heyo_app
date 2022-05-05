import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_manager.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

class GlobalBindings extends Bindings {
  final p2pNode = P2PNode(
      accountInfo: AccountManager(
          localProvider: SecureStorageProvider(),
          cryptographyKeyGenerator: Web3Keys()),
      p2pNodeRequestStream: P2PNodeRequestStream(),
      p2pNodeResponseStream: P2PNodeResponseStream());

  @override
  void dependencies() {
    Get.put(ChatsController());
    Get.put<P2PNodeManager>(P2PNodeManager(p2pNode: p2pNode));
  }
}

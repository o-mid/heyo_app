import 'package:core_web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/connection/data/libp2p_connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/messages/connection/multiple_connections.dart';
import 'package:heyo/app/modules/messages/connection/single_webrtc_connection.dart';
import 'package:heyo/app/modules/messages/connection/web_rtc_connection_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/utils/constants/web3client_constant.dart';
import 'package:heyo/contracts/Registry.g.dart';
import 'package:http/http.dart' as http;

class P2PBindings with HighPriorityBindings, NormalPriorityBindings {
  @override
  void executeHighPriorityBindings() {
    Get
      ..put<Web3Client>(
        Web3Client(
          WEB3CLIENT.url,
          http.Client(),
          WEB3CLIENT.username,
          WEB3CLIENT.password,
        ),
        permanent: true,
      )
      ..put<BlockchainProvider>(
        BlockchainProviderImpl(
          storageProvider: Get.find(),
          web3client: Get.find(),
        ),
        permanent: true,
      );
  }

  @override
  void executeNormalPriorityBindings() {
    Get
      ..put<Registry>(
        Registry(
          address: XCBAddress.fromHex(REGISTRY_ADDR),
          client: Get.find(),

          /// Here we should pass network id which is variable that should
          /// be extracted from web3client
          chainId: 3,
        ),
      )
      ..put(
        P2PState(),
        permanent: true,
      )
      ..put(ConnectionController(p2pState: Get.find()))
      ..put(
        P2PCommunicator(
          p2pState: Get.find(),
          libP2PStorageProvider: Get.find(),
        ),
      )
      ..put(
        P2PNodeRequestStream(
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put(
        P2PNodeResponseStream(
          p2pState: Get.find(),
          libP2PStorageProvider: Get.find(),
          accountRepository: Get.find(),
          sendEventProvider: Get.find(),
          connectionController: Get.find(),
        ),
        permanent: true,
      )
      ..put<P2PNodeController>(
        P2PNodeController(
          p2pNode: P2PNode(
            p2pNodeRequestStream: Get.find(),
            p2pNodeResponseStream: Get.find(),
            p2pState: Get.find(),
            web3client: Get.find(),
            libP2PStorageProvider: Get.find(),
            accountCreation: Get.find(),
          ),
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put<ConnectionContractor>(
        LibP2PConnectionContractor(
          p2pNodeController: Get.find(),
          p2pCommunicator: Get.find(),
        ),
        permanent: true,
      )
      ..put(
        MultipleConnectionHandler(
          connectionContractor: Get.find(),
          singleWebRTCConnection: SingleWebRTCConnection(
            connectionContractor: Get.find(),
            webRTCConnectionManager: WebRTCConnectionManager(),
          ),
        ),
        permanent: true,
      );

  }
}

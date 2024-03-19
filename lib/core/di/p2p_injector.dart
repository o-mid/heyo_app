import 'package:core_web3dart/web3dart.dart';
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
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/utils/constants/web3client_constant.dart';
import 'package:heyo/contracts/Registry.g.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';
import 'package:http/http.dart' as http;

class P2PInjector with HighPriorityInjector, NormalPriorityInjector {
  @override
  void executeHighPriorityInjector() {
    inject
      ..registerSingleton<Web3Client>(
        Web3Client(
          WEB3CLIENT.url,
          http.Client(),
          WEB3CLIENT.username,
          WEB3CLIENT.password,
        ),
        //permanent: true,
      )
      ..registerSingleton<BlockchainProvider>(
        BlockchainProviderImpl(
          storageProvider: inject.get(),
          web3client: inject.get(),
        ),
        //permanent: true,
      );
  }

  @override
  void executeNormalPriorityInjector() {
    inject
      ..registerSingleton<Registry>(
        Registry(
          address: XCBAddress.fromHex(REGISTRY_ADDR),
          client: inject.get(),

          /// Here we should pass network id which is variable that should
          /// be extracted from web3client
          chainId: 3,
        ),
      )
      ..registerSingleton(
        P2PState(),
        //permanent: true,
      )
      ..registerSingleton(ConnectionController(p2pState: inject.get()))
      ..registerSingleton(
        P2PCommunicator(
          p2pState: inject.get(),
          libP2PStorageProvider: inject.get(),
        ),
      )
      ..registerSingleton(
        P2PNodeRequestStream(
          p2pState: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton(
        P2PNodeResponseStream(
          p2pState: inject.get(),
          libP2PStorageProvider: inject.get(),
          accountRepository: inject.get(),
          sendEventProvider: inject.get(),
          connectionController: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton<P2PNodeController>(
        P2PNodeController(
          p2pNode: P2PNode(
            p2pNodeRequestStream: inject.get(),
            p2pNodeResponseStream: inject.get(),
            p2pState: inject.get(),
            web3client: inject.get(),
            libP2PStorageProvider: inject.get(),
            accountCreation: inject.get(),
          ),
          p2pState: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton<ConnectionContractor>(
        LibP2PConnectionContractor(
          p2pNodeController: inject.get(),
          p2pCommunicator: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton(
        MultipleConnectionHandler(
          connectionContractor: inject.get(),
          singleWebRTCConnection: SingleWebRTCConnection(
            connectionContractor: inject.get(),
            webRTCConnectionManager: WebRTCConnectionManager(),
          ),
        ),
        //permanent: true,
      );
  }
}

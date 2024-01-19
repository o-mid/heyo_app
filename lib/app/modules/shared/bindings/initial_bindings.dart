import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/dio/dio_network_request.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..put<NetworkRequest>(DioNetworkRequest(), permanent: true)
      ..put<LibP2PStorageProvider>(
        LibP2PStorageProvider(
          localProvider: GlobalBindings.secureStorageProvider,
        ),
      )
      ..put<BlockchainProvider>(
        BlockchainProviderImpl(
          storageProvider: GlobalBindings.secureStorageProvider,
          web3client: GlobalBindings.web3Client,
        ),
        permanent: true,
      );
  }
}

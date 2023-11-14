import 'package:core_web3dart/web3dart.dart';

abstract class BlockchainProvider {
  Future<List<dynamic>> queryContract(
    String functionName,
    List<dynamic> args,
    DeployedContract contract,
    Web3Client web3,
  );

  Future<DeployedContract> loadContract(
    String contractAddress,
    String contractAbi,
    String contractName,
  );
}

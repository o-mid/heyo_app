import 'package:core_web3dart/src/contracts/deployed_contract.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:flutter/services.dart';

class AppBlockchainProvider extends BlockchainProvider {
  @override
  Future<DeployedContract> loadContract(
      String contractAddress, String contractAbi, String contractName) async {
    final abi = await rootBundle.loadString(contractAbi);
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      XCBAddress.fromHex(contractAddress),
    );
    return contract;
  }

  @override
  Future<List> queryContract(String functionName, List args,
      DeployedContract contract, Web3Client web3) async {
    final ethFunction = contract.function(functionName);
    try {
      final result = await web3.call(
        contract: contract,
        params: args,
        function: ethFunction,
      );
      return result;
    } catch (err, trace) {
      if (kDebugMode) {
        print(trace.toString());
        print(err.toString());
      }
    }
    return [];
  }
}

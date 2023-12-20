// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core_web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"AdminChanged","type":"event"},{"anonymous":false,"inputs":[],"name":"ContractDeprecated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"key","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"value","type":"bytes"}],"name":"FieldSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"RoleRevoked","type":"event"},{"inputs":[],"name":"admin","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"changeAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"deprecateContract","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"key","type":"bytes32"}],"name":"get","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getAll","outputs":[{"internalType":"bytes32[]","name":"","type":"bytes32[]"},{"internalType":"bytes[]","name":"","type":"bytes[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"isDeprecated","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"key","type":"bytes32"},{"internalType":"bytes","name":"value","type":"bytes"}],"name":"set","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"keys","type":"bytes32[]"},{"internalType":"bytes[]","name":"values","type":"bytes[]"}],"name":"setBatch","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'Registry',
);

class Registry extends _i1.GeneratedContract {
  Registry({
    required _i1.XCBAddress address,
    required _i1.Web3Client client,
    required int chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.XCBAddress> admin({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.XCBAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> changeAdmin(
    _i1.XCBAddress account, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    final params = [account];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> deprecateContract({
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    final params = [];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> get(
    _i2.Uint8List key, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[3];
    final params = [key];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetAll> getAll({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return GetAll(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> grantRole(
    _i2.Uint8List role,
    _i1.XCBAddress account, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    final params = [
      role,
      account,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> hasRole(
    _i2.Uint8List role,
    _i1.XCBAddress account, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    final params = [
      role,
      account,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> isDeprecated({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[7];
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> renounceRole(
    _i2.Uint8List role, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    final params = [role];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> revokeRole(
    _i2.Uint8List role,
    _i1.XCBAddress account, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    final params = [
      role,
      account,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> set(
    _i2.Uint8List key,
    _i2.Uint8List value, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    final params = [
      key,
      value,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setBatch(
    List<_i2.Uint8List> keys,
    List<_i2.Uint8List> values, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[11];
    final params = [
      keys,
      values,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all AdminChanged events emitted by this contract.
  Stream<AdminChanged> adminChangedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AdminChanged');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return AdminChanged(decoded);
    });
  }

  /// Returns a live stream of all ContractDeprecated events emitted by this contract.
  Stream<ContractDeprecated> contractDeprecatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('ContractDeprecated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return ContractDeprecated(decoded);
    });
  }

  /// Returns a live stream of all FieldSet events emitted by this contract.
  Stream<FieldSet> fieldSetEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('FieldSet');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return FieldSet(decoded);
    });
  }

  /// Returns a live stream of all RoleGranted events emitted by this contract.
  Stream<RoleGranted> roleGrantedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('RoleGranted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return RoleGranted(decoded);
    });
  }

  /// Returns a live stream of all RoleRevoked events emitted by this contract.
  Stream<RoleRevoked> roleRevokedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('RoleRevoked');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return RoleRevoked(decoded);
    });
  }
}

class GetAll {
  GetAll(List<dynamic> response)
      : var1 = (response[0] as List<dynamic>).cast<_i2.Uint8List>(),
        var2 = (response[1] as List<dynamic>).cast<_i2.Uint8List>();

  final List<_i2.Uint8List> var1;

  final List<_i2.Uint8List> var2;
}

class AdminChanged {
  AdminChanged(List<dynamic> response)
      : account = (response[0] as _i1.XCBAddress);

  final _i1.XCBAddress account;
}

class ContractDeprecated {
  ContractDeprecated(List<dynamic> response);
}

class FieldSet {
  FieldSet(List<dynamic> response)
      : key = (response[0] as _i2.Uint8List),
        value = (response[1] as _i2.Uint8List);

  final _i2.Uint8List key;

  final _i2.Uint8List value;
}

class RoleGranted {
  RoleGranted(List<dynamic> response)
      : role = (response[0] as _i2.Uint8List),
        account = (response[1] as _i1.XCBAddress);

  final _i2.Uint8List role;

  final _i1.XCBAddress account;
}

class RoleRevoked {
  RoleRevoked(List<dynamic> response)
      : role = (response[0] as _i2.Uint8List),
        account = (response[1] as _i1.XCBAddress);

  final _i2.Uint8List role;

  final _i1.XCBAddress account;
}

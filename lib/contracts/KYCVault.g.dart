// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core_web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"AdminChanged","type":"event"},{"anonymous":false,"inputs":[],"name":"ContractDeprecated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"submission","type":"uint256"},{"indexed":false,"internalType":"string","name":"reason","type":"string"}],"name":"Invalidated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"submission","type":"uint256"}],"name":"Removed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"submission","type":"uint256"},{"indexed":true,"internalType":"address","name":"user","type":"address"}],"name":"Submitted","type":"event"},{"inputs":[],"name":"admin","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address[]","name":"users","type":"address[]"},{"internalType":"bytes32[]","name":"fields","type":"bytes32[]"},{"internalType":"bytes32[]","name":"fingerprints","type":"bytes32[]"}],"name":"batchIsValid","outputs":[{"internalType":"bool[]","name":"","type":"bool[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address[]","name":"users","type":"address[]"},{"internalType":"bytes32[]","name":"fields","type":"bytes32[]"}],"name":"batchIsVerified","outputs":[{"internalType":"bool[]","name":"","type":"bool[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"changeAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"deprecateContract","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"field_","type":"bytes32"}],"name":"field","outputs":[{"components":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"bool","name":"required","type":"bool"},{"internalType":"bool","name":"complete","type":"bool"}],"internalType":"struct Field","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"},{"internalType":"bytes32","name":"field_","type":"bytes32"},{"internalType":"uint256","name":"submission_","type":"uint256"}],"name":"fingerprint","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"submissions_","type":"uint256[]"},{"internalType":"string[]","name":"reasons","type":"string[]"}],"name":"invalidate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"isDeprecated","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"},{"internalType":"bytes32","name":"field_","type":"bytes32"},{"internalType":"bytes32","name":"fingerprint_","type":"bytes32"}],"name":"isValid","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"},{"internalType":"bytes32","name":"field_","type":"bytes32"}],"name":"isVerified","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"submission_","type":"uint256"},{"internalType":"bytes","name":"signature","type":"bytes"}],"name":"remove","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32[]","name":"fields_","type":"bytes32[]"},{"internalType":"bool[]","name":"requireds","type":"bool[]"},{"internalType":"bool[]","name":"completes","type":"bool[]"}],"name":"setFields","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"bytes32[]","name":"fields_","type":"bytes32[]"}],"name":"setRoleFields","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"submission_","type":"uint256"}],"name":"submission","outputs":[{"components":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"uint256","name":"expiration","type":"uint256"},{"internalType":"address","name":"user","type":"address"},{"internalType":"bool","name":"removed","type":"bool"},{"internalType":"bool","name":"invalidated","type":"bool"}],"internalType":"struct Submission","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"components":[{"internalType":"uint256","name":"expiration","type":"uint256"},{"internalType":"address","name":"user","type":"address"},{"internalType":"bytes32[]","name":"fingerprints","type":"bytes32[]"}],"internalType":"struct Info[]","name":"infos","type":"tuple[]"}],"name":"submit","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"}]',
  'KYCVault',
);

class KYCVault extends _i1.GeneratedContract {
  KYCVault({
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<bool>> batchIsValid(
    List<_i1.XCBAddress> users,
    List<_i2.Uint8List> fields,
    List<_i2.Uint8List> fingerprints, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[1];
    final params = [
      users,
      fields,
      fingerprints,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<bool>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<bool>> batchIsVerified(
    List<_i1.XCBAddress> users,
    List<_i2.Uint8List> fields, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    final params = [
      users,
      fields,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<bool>();
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> changeAdmin(
    _i1.XCBAddress account, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
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
    final function = self.abi.functions[4];
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
  Future<dynamic> field(
    _i2.Uint8List field_, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    final params = [field_];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> fingerprint(
    _i1.XCBAddress user,
    _i2.Uint8List field_,
    BigInt submission_, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    final params = [
      user,
      field_,
      submission_,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
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
    final function = self.abi.functions[7];
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
    final function = self.abi.functions[8];
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> invalidate(
    List<BigInt> submissions_,
    List<String> reasons, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    final params = [
      submissions_,
      reasons,
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
  Future<bool> isDeprecated({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[10];
    final params = [];
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
  Future<bool> isValid(
    _i1.XCBAddress user,
    _i2.Uint8List field_,
    _i2.Uint8List fingerprint_, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
    final params = [
      user,
      field_,
      fingerprint_,
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
  Future<bool> isVerified(
    _i1.XCBAddress user,
    _i2.Uint8List field_, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[12];
    final params = [
      user,
      field_,
    ];
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
  Future<String> remove(
    BigInt submission_,
    _i2.Uint8List signature, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[13];
    final params = [
      submission_,
      signature,
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
  Future<String> renounceRole(
    _i2.Uint8List role, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[14];
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
    final function = self.abi.functions[15];
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
  Future<String> setFields(
    List<_i2.Uint8List> fields_,
    List<bool> requireds,
    List<bool> completes, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[16];
    final params = [
      fields_,
      requireds,
      completes,
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
  Future<String> setRoleFields(
    _i2.Uint8List role,
    List<_i2.Uint8List> fields_, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[17];
    final params = [
      role,
      fields_,
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
  Future<dynamic> submission(
    BigInt submission_, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    final params = [submission_];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> submit(
    _i2.Uint8List role,
    List<dynamic> infos, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[19];
    final params = [
      role,
      infos,
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

  /// Returns a live stream of all Invalidated events emitted by this contract.
  Stream<Invalidated> invalidatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Invalidated');
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
      return Invalidated(decoded);
    });
  }

  /// Returns a live stream of all Removed events emitted by this contract.
  Stream<Removed> removedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Removed');
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
      return Removed(decoded);
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

  /// Returns a live stream of all Submitted events emitted by this contract.
  Stream<Submitted> submittedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Submitted');
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
      return Submitted(decoded);
    });
  }
}

class AdminChanged {
  AdminChanged(List<dynamic> response)
      : account = (response[0] as _i1.XCBAddress);

  final _i1.XCBAddress account;
}

class ContractDeprecated {
  ContractDeprecated(List<dynamic> response);
}

class Invalidated {
  Invalidated(List<dynamic> response)
      : submission = (response[0] as BigInt),
        reason = (response[1] as String);

  final BigInt submission;

  final String reason;
}

class Removed {
  Removed(List<dynamic> response) : submission = (response[0] as BigInt);

  final BigInt submission;
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

class Submitted {
  Submitted(List<dynamic> response)
      : submission = (response[0] as BigInt),
        user = (response[1] as _i1.XCBAddress);

  final BigInt submission;

  final _i1.XCBAddress user;
}

import 'package:core_web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/account_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/messaging_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/network_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/p2p_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/storage_bindings.dart';

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    // p2p related bindings

    StorageBindings().executeHighPriorityBindings();
    AccountBindings().executeHighPriorityBindings();
    P2PBindings().executeHighPriorityBindings();
    NetworkBindings().executeHighPriorityBindings();
    MessagingBindings().executeHighPriorityBindings();
  }
}

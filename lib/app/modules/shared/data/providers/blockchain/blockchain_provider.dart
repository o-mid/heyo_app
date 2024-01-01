import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';

abstract class BlockchainProvider {
  Future<void> init();

  Future<KYCVault?> getKYCVault();

  Future<Registry> getRegistryAbi();
}

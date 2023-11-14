import 'package:heyo/app/modules/shared/data/models/get_all_contract_model.dart';
import 'package:heyo/app/modules/shared/data/models/registry_info_model.dart';

abstract class RegistryProvider {
  Future<GetAllContractModel> getAll();

  Future<void> saveRegistry(RegistryInfoModel registryInfoModel);

  Future<RegistryInfoModel> getRegistry();
}

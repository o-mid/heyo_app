import 'package:core_web3dart/credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provider.dart';
import 'package:heyo/app/modules/shared/utils/constants/web3client_constant.dart';
import 'package:heyo/contracts/KYCVault.g.dart';

class KycVaultProviderImpl extends KycVaultProvider {
  KycVaultProviderImpl(this.kycVault);

  late KYCVault kycVault;

  @override
  Future<Map<String, bool>> isUserVerified(List<String> coreIds) async {
    final searchingFields = [
      getSha3ForNames(MINTABLE_FIELDS.IDCARD_NAME),
      getSha3ForNames(MINTABLE_FIELDS.IDCARD_NAME_EN),
      getSha3ForNames(MINTABLE_FIELDS.ADDRESS_NAME),
      getSha3ForNames(MINTABLE_FIELDS.ADDRESS_NAME_EN),
      getSha3ForNames(MINTABLE_FIELDS.DRIVER_LICENSE_NAME),
      getSha3ForNames(MINTABLE_FIELDS.DRIVER_LICENSE_NAME_EN),
      getSha3ForNames(MINTABLE_FIELDS.PASSPORT_NAME),
      getSha3ForNames(MINTABLE_FIELDS.RESIDENCE_PERMIT_NAME),
      getSha3ForNames(MINTABLE_FIELDS.PASSPORT_NAME_EN),
    ];
    final verificationStatus = <String, bool>{};
    for (var coreId in coreIds) {
      final result = await kycVault.batchIsVerified(
        List.filled(searchingFields.length, XCBAddress.fromHex(coreId)),
        searchingFields,
      );

      final atLeastOneValidName = result.any((element) => element == true);
      verificationStatus[coreId] = atLeastOneValidName;
    }

    return verificationStatus;
  }
}

abstract class KycVaultProvider {
  Future<Map<String, bool>> isUserVerified(List<String> coreIds);
}

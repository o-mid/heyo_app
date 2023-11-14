class CreateAccountResult {
  final String coreId;
  final String privateKey;
  final List<String> phrases;
  final String address;
  final String pubKey;

  CreateAccountResult({
    required this.coreId,
    required this.privateKey,
    required this.phrases,
    required this.address,
    required this.pubKey,
  });
}
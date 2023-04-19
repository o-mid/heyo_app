/// [ProfileModel] document structure :

/// Variable          | Data Type | Description                                    | Required? | Default Value (if not required)
/// ------------------|----------|------------------------------------------------|-----------|------------------------------------
/// name              | String   | The name of the user's profile.                 | Yes       | N/A
/// walletAddress     | String   | The wallet address associated with the profile. | Yes       | N/A
/// link              | String   | A link to the user's profile page.              | Yes       | N/A

class ProfileModel {
  String name;
  String walletAddress;
  String link;

  ProfileModel({
    required this.name,
    required this.walletAddress,
    required this.link,
  });
}

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

/// [UserModel] document structure :

/// |      Variable        |    Data Type  |                         Description                        | Default Value ((N/A) = required)|
/// |----------------------|---------------|----------------------------------------------------------|--------------|
/// | name                 | String        | Name of the user.                                          | N/A          |
/// | icon                 | String        | Icon URL for the user.                                     | N/A          |
/// | walletAddress        | String        | The wallet address associated with the user.               | N/A          |
/// | nickname             | String        | The nickname for the user.                                 | ""           |
/// | isOnline             | bool          | Indicates if the user is currently online.                 | false        |
/// | isVerified           | bool          | Indicates if the user is verified.                         | false        |
/// | isContact            | bool          | Indicates if the user is a contact.                        | false        |
/// |----------------------|---------------|----------------------------------------------------------|--------------|

class UserModel {
  static const nameSerializedName = 'name';
  static const iconUrlSerializedName = 'iconUrl';
  static const walletAddressSerializedName = 'walletAddress';
  static const nicknameSerializedName = 'nickname';
  static const isVerifiedSerializedName = 'isVerified';
  static const isContactSerializedName = 'isContact';
  static const chatModelSerializedName = 'chatModel';
  static const isBlockedSerializedName = 'isBlocked';
  static const isOnlineSerializedName = 'isOnline';
  static const coreIdSerializedName = 'coreId';

  String name;
  String iconUrl;
  String walletAddress;
  String nickname;
  bool isOnline;
  bool isVerified;
  bool isBlocked;
  bool isContact;
  String coreId;

  UserModel({
    required this.name,
    required this.iconUrl,
    required this.walletAddress,
    this.isContact = false,
    this.isOnline = false,
    this.isVerified = false,
    this.isBlocked = false,
    this.nickname = "",
    required this.coreId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json[nameSerializedName],
        iconUrl: json[iconUrlSerializedName],
        walletAddress: json[walletAddressSerializedName],
        nickname: json[nicknameSerializedName],
        isVerified: json[isVerifiedSerializedName],
        isContact: json[isContactSerializedName],
        isBlocked: json[isBlockedSerializedName],
        isOnline: json[isOnlineSerializedName],
        coreId: json[coreIdSerializedName],
      );

  Map<String, dynamic> toJson() => {
        nameSerializedName: name,
        iconUrlSerializedName: iconUrl,
        walletAddressSerializedName: walletAddress,
        nicknameSerializedName: nickname,
        isVerifiedSerializedName: isVerified,
        isContactSerializedName: isContact,
        isBlockedSerializedName: isBlocked,
        isOnlineSerializedName: isOnline,
        coreIdSerializedName: coreId,
      };

  UserModel copyWith({
    String? name,
    String? icon,
    String? walletAddress,
    String? nickname,
    bool? isOnline,
    bool? isVerified,
    bool? isContact,
    bool? isBlocked,
    String? coreId,
    String? iconUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      iconUrl: icon ?? this.iconUrl,
      walletAddress: walletAddress ?? this.walletAddress,
      nickname: nickname ?? this.nickname,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      isContact: isContact ?? this.isContact,
      isBlocked: isBlocked ?? this.isBlocked,
      coreId: coreId ?? this.coreId,
    );
  }
}

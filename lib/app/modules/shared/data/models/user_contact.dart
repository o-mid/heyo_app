///  [UserContact] document structure :

///  Variable  | Data Type | Description                            | Required | Default Value ((N/A) = required)
///  --------- | --------- | -------------------------------------- | -------- | -------------
///  coreId    | String    | The core ID of the user contact.        | Yes      | N/A
///  nickname  | String    | The nickname of the user contact.       | Yes      | N/A
///  icon      | String    | The icon representing the user contact. | Yes      | N/A

class UserContact {
  static const coreIdSerializedName = "coreId";
  static const nicknameSerializedName = "nickname";
  static const iconSerializedName = "icon";

  String coreId;
  String nickname;
  String icon;

  UserContact({
    required this.coreId,
    required this.nickname,
    required this.icon,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) => UserContact(
        coreId: json[coreIdSerializedName],
        nickname: json[nicknameSerializedName],
        icon: json[iconSerializedName],
      );

  Map<String, dynamic> toJson() => {
        coreIdSerializedName: coreId,
        nicknameSerializedName: nickname,
        iconSerializedName: icon,
      };
}

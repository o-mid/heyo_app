import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

class UserModel {
  static const nameSerializedName = 'name';
  static const iconSerializedName = 'icon';
  static const walletAddressSerializedName = 'walletAddress';
  static const nicknameSerializedName = 'nickname';
  static const isVerifiedSerializedName = 'isVerified';
  static const isContactSerializedName = 'isContact';
  static const chatModelSerializedName = 'chatModel';

  String name;
  String icon;
  String walletAddress;
  String nickname;
  bool isOnline;
  bool isVerified;
  ChatModel chatModel;
  bool isContact;

  UserModel({
    required this.name,
    required this.icon,
    required this.walletAddress,
    this.isContact = false,
    this.isOnline = false,
    this.isVerified = false,
    this.nickname = "",
    required this.chatModel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json[nameSerializedName],
        icon: json[iconSerializedName],
        walletAddress: json[walletAddressSerializedName],
        nickname: json[nicknameSerializedName],
        isVerified: json[isVerifiedSerializedName],
        isContact: json[isContactSerializedName],
        chatModel: json[chatModelSerializedName],
      );

  Map<String, dynamic> toJson() => {
        nameSerializedName: name,
        iconSerializedName: icon,
        walletAddressSerializedName: walletAddress,
        nicknameSerializedName: nickname,
        isVerifiedSerializedName: isVerified,
        isContactSerializedName: isContact,
        chatModelSerializedName: chatModel,
      };

  UserModel copyWith({
    String? name,
    String? icon,
    String? walletAddress,
    String? nickname,
    bool? isOnline,
    bool? isVerified,
    ChatModel? chatModel,
    bool? isContact,
  }) {
    return UserModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      walletAddress: walletAddress ?? this.walletAddress,
      nickname: nickname ?? this.nickname,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      chatModel: chatModel ?? this.chatModel,
      isContact: isContact ?? this.isContact,
    );
  }
}

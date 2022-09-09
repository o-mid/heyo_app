class ReactionModel {
  static const usersSerializedName = 'users';
  static const isReactedByMeSerializedName = 'isReactedByMe';

  /// List of user ids that have reacted
  final List<String> users;
  final bool isReactedByMe;

  ReactionModel({this.users = const [], this.isReactedByMe = false});

  ReactionModel copyWith({
    List<String>? users,
    bool? isReactedByMe,
  }) =>
      ReactionModel(
        users: users ?? this.users,
        isReactedByMe: isReactedByMe ?? this.isReactedByMe,
      );

  factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
        users: List<String>.from(json[usersSerializedName].map((x) => x)),
        isReactedByMe: json[isReactedByMeSerializedName],
      );

  Map<String, dynamic> toJson() => {
        usersSerializedName: List<dynamic>.from(users.map((x) => x)),
        isReactedByMeSerializedName: isReactedByMe,
      };
}

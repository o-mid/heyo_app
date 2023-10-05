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
        users: json[usersSerializedName] == null
            ? []
            : List<String>.from(json[usersSerializedName] as Iterable<dynamic>),
        isReactedByMe: json[isReactedByMeSerializedName] as bool,
      );

  Map<String, dynamic> toJson() => {
        usersSerializedName: List<dynamic>.from(users.map((x) => x)),
        isReactedByMeSerializedName: isReactedByMe,
      };
}

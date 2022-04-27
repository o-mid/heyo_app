class ReactionModel {
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
}

class MessagingParticipantModel {
  final String coreId;
  final String chatId;
  final String? name;

  MessagingParticipantModel({
    required this.coreId,
    required this.chatId,
    this.name,
  });

  factory MessagingParticipantModel.fromJson(Map<String, dynamic> json) =>
      MessagingParticipantModel(
        coreId: json['coreId'],
        chatId: json['chatId'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'coreId': coreId,
        'chatId': chatId,
        'name': name,
      };

  MessagingParticipantModel copyWith({
    String? coreId,
    String? chatId,
    String? name,
  }) {
    return MessagingParticipantModel(
      coreId: coreId ?? this.coreId,
      chatId: chatId ?? this.chatId,
      name: name ?? this.name,
    );
  }
}

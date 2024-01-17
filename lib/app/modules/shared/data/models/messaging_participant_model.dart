class MessagingParticipantModel {
  final String coreId;
  final String chatId;

  MessagingParticipantModel({
    required this.coreId,
    required this.chatId,
  });

  factory MessagingParticipantModel.fromJson(Map<String, dynamic> json) =>
      MessagingParticipantModel(
        coreId: json['coreId'],
        chatId: json['chatId'],
      );

  Map<String, dynamic> toJson() => {
        'coreId': coreId,
        'chatId': chatId,
      };
}

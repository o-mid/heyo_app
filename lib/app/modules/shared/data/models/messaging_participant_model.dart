class MessagingParticipantModel {
  final String coreId;

  MessagingParticipantModel({
    required this.coreId,
  });

  factory MessagingParticipantModel.fromJson(Map<String, dynamic> json) =>
      MessagingParticipantModel(
        coreId: json['coreId'],
      );

  Map<String, dynamic> toJson() => {
        'coreId': coreId,
      };
}

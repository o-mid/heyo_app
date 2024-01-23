import 'messages/message_model.dart';

class MessageReceiptModel {
  MessageReceiptModel({
    required this.coreId,
    required this.timestamp,
    required this.messageStatus,
  });
  static const coreIdSerializedName = 'coreId';
  static const timestampSerializedName = 'timestamp';
  static const messageStatusSerializedName = 'messageStatus';

  final String coreId;
  final DateTime timestamp;
  final MessageStatus messageStatus;

  factory MessageReceiptModel.fromJson(Map<String, dynamic> json) => MessageReceiptModel(
        coreId: json[coreIdSerializedName],
        timestamp: DateTime.parse(json[timestampSerializedName]),
        messageStatus: MessageStatus.values.byName(json[messageStatusSerializedName]),
      );

  Map<String, dynamic> toJson() => {
        coreIdSerializedName: coreId,
        timestampSerializedName: timestamp.toIso8601String(),
        messageStatusSerializedName: messageStatus.name,
      };
}

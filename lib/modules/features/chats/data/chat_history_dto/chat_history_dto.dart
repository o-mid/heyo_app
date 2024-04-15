import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_history_model.dart';

part 'chat_history_dto.freezed.dart';
part 'chat_history_dto.g.dart';

@freezed
class ChatHistoryDTO with _$ChatHistoryDTO {
  @JsonSerializable(explicitToJson: true)
  const factory ChatHistoryDTO({
    required String id,
    required String name,
    required String lastMessage,
    required DateTime timestamp,
    required String lastReadMessageId,
    required List<MessagingParticipantModel> participants,
    @Default(0) int notificationCount,
    @Default('') String scrollPosition,
    @Default(false) bool isGroupChat,
    @Default('') String creatorCoreId,
  }) = _ChatHistoryDTO;

  factory ChatHistoryDTO.fromJson(Map<String, dynamic> json) => _$ChatHistoryDTOFromJson(json);
}

extension ChatDTOMapper on ChatHistoryDTO {
  ChatHistoryModel toChatModel() {
    return ChatHistoryModel(
      id: id,
      name: name,
      lastMessage: lastMessage,
      timestamp: timestamp,
      lastReadMessageId: lastReadMessageId,
      participants: participants,
      notificationCount: notificationCount,
      scrollPosition: scrollPosition,
      isGroupChat: isGroupChat,
      creatorCoreId: creatorCoreId,
    );
  }
}

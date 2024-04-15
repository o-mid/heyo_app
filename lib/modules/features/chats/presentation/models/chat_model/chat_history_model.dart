import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/modules/features/chats/data/chat_history_dto/chat_history_dto.dart';

part 'chat_history_model.freezed.dart';
part 'chat_history_model.g.dart';

@freezed
class ChatHistoryModel with _$ChatHistoryModel {
  @JsonSerializable(explicitToJson: true)
  const factory ChatHistoryModel({
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
  }) = _ChatHistoryModel;

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => _$ChatHistoryModelFromJson(json);
}

extension ContactModelMapper on ChatHistoryModel {
  // ChatHistoryModel toViewModel() {
  //   return ChatHistoryModel(
  //     id: id,
  //     name: name,
  //     lastMessage: lastMessage,
  //     timestamp: timestamp,
  //     participants: participants,
  //     notificationCount: notificationCount,
  //     isGroupChat: isGroupChat,
  //   );
  //}

  ChatHistoryDTO toChatHistoryDTO() {
    return ChatHistoryDTO(
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

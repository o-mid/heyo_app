import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_view_model/chat_view_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  @JsonSerializable(explicitToJson: true)
  const factory ChatModel({
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
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
}

extension ChatModelExtension on ChatModel {
  ChatViewModel toViewModel() {
    return ChatViewModel(
      id: id,
      name: name,
      lastMessage: lastMessage,
      timestamp: timestamp,
      participants: participants,
      notificationCount: notificationCount,
      isGroupChat: isGroupChat,
    );
  }
}

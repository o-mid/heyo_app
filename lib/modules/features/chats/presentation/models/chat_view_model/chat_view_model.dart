import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart'; // For JSON serialization

@freezed
class ChatViewModel with _$ChatViewModel {
  @JsonSerializable(explicitToJson: true) // Enable explicit JSON serialization
  const factory ChatViewModel({
    required String id,
    required String name,
    required String lastMessage,
    required DateTime timestamp,
    required List<MessagingParticipantModel> participants,
    @Default(0) int notificationCount,
    @Default(false) bool isGroupChat,
  }) = _ChatViewModel;

  factory ChatViewModel.fromJson(Map<String, dynamic> json) => _$ChatViewModelFromJson(json);
}

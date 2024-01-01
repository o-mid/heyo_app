import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';

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
    @Default(false) bool isOnline,
    @Default(false) bool isVerified,
    @Default(0) int notificationCount,
    @Default('') String scrollPosition,
    required String lastReadMessageId,
    required List<MessagingParticipantModel> participants,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
}

/// [ChatModel] document structure :

/// |      Variable        |    Data Type  |                         Description                        | Default Value ((N/A) = required)|
/// |----------------------|---------------|----------------------------------------------------------|--------------|
/// | id                   | String        | Unique identifier for the chat.                            | N/A          |
/// | name                 | String        | Name of the chat.                                          | N/A          |
/// | icon                 | String        | Icon URL for the chat.                                     | N/A          |
/// | lastMessage          | String        | The last message in the chat.                              | N/A          |
/// | timestamp            | DateTime      | The timestamp of the last message.                         | N/A          |
/// | isOnline             | bool          | Indicates if the user is currently online.                 | false        |
/// | isVerified           | bool          | Indicates if the user is verified.                         | false        |
/// | notificationCount    | int           | The number of unread messages in the chat.                 | 0            |
/// |----------------------|---------------|----------------------------------------------------------|--------------|


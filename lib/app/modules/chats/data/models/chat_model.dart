import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';

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

class ChatModel {
  static const idSerializedName = 'id';
  static const coreIdSerializedName = 'coreId';
  static const nameSerializedName = 'name';

  static const lastMessageSerializedName = 'lastMessage';
  static const timestampSerializedName = 'timestamp';
  static const isOnlineSerializedName = 'isOnline';
  static const isVerifiedSerializedName = 'isVerified';
  static const notificationCountSerializedName = 'notificationCount';
  static const lastReadMessageIdSerializedName = 'lastReadMessageId';
  static const scrollPositionSerializedName = "scrollPosition";
  static const participantsSerializedName = "participants";

  final String id;
  final String name;

  final String lastMessage;
  final DateTime timestamp;
  final bool isOnline;
  final bool isVerified;
  final int notificationCount;
  final String scrollPosition;
  final String lastReadMessageId;
  final List<MessagingParticipantModel> participants;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.isOnline = false,
    this.isVerified = false,
    this.notificationCount = 0,
    // should be required after implementing the feature and refactoring
    this.scrollPosition = '',
    required this.lastReadMessageId,
    required this.participants,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json[idSerializedName] as String,
        name: json[nameSerializedName] as String,
        lastMessage: json[lastMessageSerializedName] as String,
        timestamp: DateTime.parse(json[timestampSerializedName] as String),
        isOnline: json[isOnlineSerializedName] as bool,
        isVerified: json[isVerifiedSerializedName] as bool,
        notificationCount: json[notificationCountSerializedName] as int,
        lastReadMessageId: json[lastReadMessageIdSerializedName] as String,
        scrollPosition: json[scrollPositionSerializedName] as String,
        participants: (json[participantsSerializedName] as List<dynamic>)
            .map((e) => MessagingParticipantModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        idSerializedName: id,
        nameSerializedName: name,
        lastMessageSerializedName: lastMessage,
        timestampSerializedName: timestamp.toIso8601String(),
        isOnlineSerializedName: isOnline,
        isVerifiedSerializedName: isVerified,
        notificationCountSerializedName: notificationCount,
        lastReadMessageIdSerializedName: lastReadMessageId,
        scrollPositionSerializedName: scrollPosition,
        participantsSerializedName: participants.map((e) => e.toJson()).toList(),
      };

  ChatModel copyWith({
    String? id,
    String? coreId,
    String? name,
    String? icon,
    String? lastMessage,
    DateTime? timestamp,
    bool? isOnline,
    bool? isVerified,
    int? notificationCount,
    String? scrollPosition,
    String? lastReadMessageId,
    List<MessagingParticipantModel>? participants,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      notificationCount: notificationCount ?? this.notificationCount,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      participants: participants ?? this.participants,
    );
  }
}

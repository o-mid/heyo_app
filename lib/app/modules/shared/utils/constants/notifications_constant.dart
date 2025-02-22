import 'colors.dart';

class NOTIFICATIONS {
  // Notifications Channels
  static const callsChannelKey = 'calls_channel';
  static const callsChannelName = 'Calls Channel';
  static const callsChannelDescription = 'Notification channel for calls';

  static const missedCallChannelName = 'Missed Calls';
  static const missedCallChannelKey = 'missed_calls';

  static const messagesChannelKey = 'messages_channel';
  static const messagesChannelName = 'Messages Channel';
  static const messagesChannelDescription = 'Notification channel for messages';

  static const defaultIcon = 'resource://drawable/res_app_icon';
  static const defaultColor = COLORS.kGreenMainColor;
}

enum MessagesActionButtons {
  reply,
  read,

  redirect,
}

enum CallsActionButtons {
  answer,
  decline,
  redirect,
}

class ReceivedNotificationActionEvent {
  String buttonKeyPressed;
  String buttonKeyInput;
  String? channelKey;
  Map<String, String?>? payload;

  ReceivedNotificationActionEvent({
    required this.buttonKeyPressed,
    required this.buttonKeyInput,
    required this.channelKey,
    required this.payload,
  });
}

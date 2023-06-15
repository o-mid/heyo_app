import 'colors.dart';

class NOTIFICATIONS {
  // Notifications Channels
  static const callsChannelKey = 'calls_channel';
  static const callsChannelName = 'Calls Channel';
  static const callsChannelDescription = 'Notification channel for calls';

  static const messagesChannelKey = 'messages_channel';
  static const messagesChannelName = 'Messages Channel';
  static const messagesChannelDescription = 'Notification channel for messages';

  static const defaultIcon = 'resource://drawable/res_app_icon';
  static const defaultColor = COLORS.kGreenMainColor;
}

enum MessagesActionButtons {
  reply,
  read,
  dismiss,
  redirect,
}

enum CallsActionButtons {
  answer,
  dismiss,
  redirect,
}

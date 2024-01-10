/// Object CallEvent.
class CallEvent {
  Event event;
  dynamic body;

  CallEvent(this.body, this.event);
  @override
  String toString() => 'CallEvent( body: $body, event: $event)';
}

enum Event {
  actionDidUpdateDevicePushTokenVoip,
  actionCallIncoming,
  actionCallStart,
  actionCallAccept,
  actionCallDecline,
  actionCallEnded,
  actionCallTimeout,
  actionCallCallback,
  actionCallToggleHold,
  actionCallToggleMute,
  actionCallToggleDmtf,
  actionCallToggleGroup,
  actionCallToggleAudioSession,
  actionCallCustom,
}

/// Using extension for backward compatibility Dart SDK 2.17.0 and lower
extension EventX on Event {
  String get name {
    switch (this) {
      case Event.actionDidUpdateDevicePushTokenVoip:
        return 'flutter_ios_call_kit.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP';
      case Event.actionCallIncoming:
        return 'flutter_ios_call_kit.ACTION_CALL_INCOMING';
      case Event.actionCallStart:
        return 'flutter_ios_call_kit.ACTION_CALL_START';
      case Event.actionCallAccept:
        return 'flutter_ios_call_kit.ACTION_CALL_ACCEPT';
      case Event.actionCallDecline:
        return 'flutter_ios_call_kit.ACTION_CALL_DECLINE';
      case Event.actionCallEnded:
        return 'flutter_ios_call_kit.ACTION_CALL_ENDED';
      case Event.actionCallTimeout:
        return 'flutter_ios_call_kit.ACTION_CALL_TIMEOUT';
      case Event.actionCallCallback:
        return 'flutter_ios_call_kit.ACTION_CALL_CALLBACK';
      case Event.actionCallToggleHold:
        return 'flutter_ios_call_kit.ACTION_CALL_TOGGLE_HOLD';
      case Event.actionCallToggleMute:
        return 'flutter_ios_call_kit.ACTION_CALL_TOGGLE_MUTE';
      case Event.actionCallToggleDmtf:
        return 'flutter_ios_call_kit.ACTION_CALL_TOGGLE_DMTF';
      case Event.actionCallToggleGroup:
        return 'flutter_ios_call_kit.ACTION_CALL_TOGGLE_GROUP';
      case Event.actionCallToggleAudioSession:
        return 'flutter_ios_call_kit.ACTION_CALL_TOGGLE_AUDIO_SESSION';
      case Event.actionCallCustom:
        return 'flutter_ios_call_kit.ACTION_CALL_CUSTOM';
    }
  }
}

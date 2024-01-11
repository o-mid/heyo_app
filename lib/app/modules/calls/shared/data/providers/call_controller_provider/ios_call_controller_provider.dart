import 'package:flutter_ios_call_kit/entities/entities.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_controller_provider/call_controller_provider.dart';

import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:uuid/uuid.dart';

class IosCallControllerProvider implements CallControllerProvider {

  IosCallControllerProvider({
    required this.accountInfoRepo,
    required this.contactRepository,
  });

  final AccountRepository accountInfoRepo;
  final ContactRepository contactRepository;

  // MARK: On Call kit call back event
  final onCallKitNewEvent = Rxn<CallEvent>();
  void onEvent(CallEvent event) {
    this.onCallKitNewEvent.value = event;
  }

  @override
  void onInit() {
    listenerEvent(onEvent);
  }

  Future<void> incomingCall(CallId callId,List<CallInfo> calls) async {

    final userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);
    final params = CallKitParams(id: Uuid().v4(), nameCaller: userModel?.name.tr, appName: "Heyo");
    await FlutterIosCallKit.showCallkitIncoming(params);
  }

  Future<void> makeCall() async {

    // Do implementation for make call with call kit
  }

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterIosCallKit.onEvent.listen((event) async {
        print('HOME: $event');
        switch (event!.event) {
          case Event.actionCallIncoming:
          // TODO: received an incoming call
            print("🟩 Event.actionCallIncoming");
            break;
          case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
            print("🟩 Event.actionCallStart");
            break;
          case Event.actionCallAccept:
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          //acceptCall();
            print("🟩 Event.actionCallAccept");
            break;
          case Event.actionCallDecline:
          // TODO: declined an incoming call
            print("🟩 Event.actionCallDecline");
            break;
          case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
            break;
          case Event.actionCallTimeout:
          // TODO: missed an incoming call
            break;
          case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.actionCallToggleHold:
          // TODO: only iOS
            break;
          case Event.actionCallToggleMute:
          // TODO: only iOS
            break;
          case Event.actionCallToggleDmtf:
          // TODO: only iOS
            break;
          case Event.actionCallToggleGroup:
          // TODO: only iOS
            break;
          case Event.actionCallToggleAudioSession:
          // TODO: only iOS
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
            break;
          case Event.actionCallCustom:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }


}

Future<void> showMockCallkitIncoming(String uuid) async {

  final params = CallKitParams(
    id: uuid,
    nameCaller: 'Hoorad',
    appName: 'Heyo',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterIosCallKit.showCallkitIncoming(params);
}
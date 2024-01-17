import 'package:flutter_ios_call_kit/entities/entities.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_controller_provider/call_controller_provider.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';

import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:uuid/uuid.dart';

class IosCallControllerProvider implements CallControllerProvider {

  IosCallControllerProvider({
    required this.accountInfoRepo,
    required this.contactRepository,
    required this.callRepository,
  }){
    listenerEvent(onEvent);
  }

  final AccountRepository accountInfoRepo;
  final ContactRepository contactRepository;
  final CallRepository callRepository;
  late CallId callId;
  late IncomingCallViewArguments args;

  String uuid = Uuid().v4();

  // MARK: On Call kit call back event
  final onCallKitNewEvent = Rxn<CallEvent>();

  void onEvent(CallEvent event) {
    onCallKitNewEvent.value = event;
  }

  Future<void> incomingCall(CallId callId,List<CallInfo> calls) async {

    this.callId = callId;
    final userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);
    final params = CallKitParams(id: uuid, nameCaller: userModel?.name.tr, appName: "Heyo");
    await FlutterIosCallKit.showCallkitIncoming(params);
  }

  Future<void> makeCall() async {

    // Do implementation for make call with call kit
  }

  Future<void> declineCall() async{

    callRepository.endOrCancelCall(callId);
    FlutterIosCallKit.endCall(uuid);
    print("🟩 declineCall");
  }

  Future<void> acceptCall() async {

    await callRepository.acceptCall(callId);
    print("🟩 acceptCall");
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
            print("🟩 Event.actionCallAccept");
            acceptCall();
            break;
          case Event.actionCallDecline:
          // TODO: declined an incoming call
            print("🟩 Event.actionCallDecline");
            callRepository.rejectIncomingCall(callId);
            break;
          case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
            print("🟩 Event.actionCallEnded");
            callRepository.endOrCancelCall(callId);
            FlutterIosCallKit.endCall(uuid);
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
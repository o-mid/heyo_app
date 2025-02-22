import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/modules/call/data/call_status_observer.dart';
import 'package:heyo/modules/call/data/call_status_provider.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

class CallHistoryObserver extends GetxController {
  CallHistoryObserver({
    required this.callHistoryRepo,
    required this.callStatusObserver,
    required this.getContactByIdUseCase,
  });

  final CallHistoryRepo callHistoryRepo;
  final CallStatusObserver callStatusObserver;
  final GetContactByIdUseCase getContactByIdUseCase;

  /// maps session id of a call to the time it started so that when it ends
  /// we can calculate the duration of call
  final _callStartTimestamps = <String, DateTime>{};

  late StreamSubscription stateListener;

  @override
  void onInit() {
    callHistoryObserver();
    super.onInit();
  }

  @override
  void onClose() {
    stateListener.cancel();
    super.onClose();
  }

  void callHistoryObserver() {
    stateListener = callStatusObserver.callHistoryState.listen((state) async {
      if (state == null) {
        return;
      }
      switch (state.callHistoryStatus) {
        case CallHistoryStatus.incoming:
          {
            await _createMissedCallRecord(
              remoteCoreId: state.remote,
              callId: state.callId,
              isAudioCall: state.isAudioCall!,
            );
            break;
          }
        case CallHistoryStatus.calling:
          {
            await _createOutgoingNotAnsweredRecord(
              remoteCoreId: state.remote,
              callId: state.callId,
              isAudioCall: state.isAudioCall!,
            );
            break;
          }
        case CallHistoryStatus.connected:
          {
            await _connectedCallHistory(state: state);
            break;
          }
        case CallHistoryStatus.left:
        case CallHistoryStatus.end:
          {
            await _endOrRejectCall(state: state);
            break;
          }
      }
    });
  }

  Future<void> _createMissedCallRecord({
    required String remoteCoreId,
    required String callId,
    required bool isAudioCall,
  }) async {
    final callParticipant = await _getUserFromCoreId(
      remoteCoreId,
    );

    final callHistory = CallHistoryModel(
      participants: [callParticipant],
      status: CallStatus.incomingMissed,
      startDate: DateTime.now(),
      callId: callId,
      type: isAudioCall ? CallType.audio : CallType.video,
    );

    await callHistoryRepo.addCallToHistory(callHistory);
  }

  Future<void> _createOutgoingNotAnsweredRecord(
      {required String remoteCoreId,
      required String callId,
      required bool isAudioCall}) async {
    final callParticipant = await _getUserFromCoreId(
      remoteCoreId,
    );

    final callHistory = CallHistoryModel(
      participants: [callParticipant],
      status: CallStatus.outgoingNotAnswered,
      startDate: DateTime.now(),
      callId: callId,
      type: isAudioCall ? CallType.audio : CallType.video,
    );

    await callHistoryRepo.addCallToHistory(callHistory);
  }

  Future<void> _endOrRejectCall({
    required CallHistoryState state,
  }) async {
    final call = await callHistoryRepo.getOneCall(state.callId);
    if (call == null) {
      return;
    }

    CallHistoryModel updateCall;

    final startTime = _callStartTimestamps[state.callId];
    if (startTime == null) {
      //* call did not connect (reject)
      final historyStatus = call.status == CallStatus.outgoingNotAnswered
          ? CallStatus.outgoingDeclined
          : CallStatus.incomingMissed;

      updateCall = call.copyWith(
        status: historyStatus,
        endDate: DateTime.now(),
      );
    } else {
      //* call connected (end)

      CallHistoryParticipantModel? participant;

      for (var i = 0; i < call.participants.length; i++) {
        if (call.participants[i].coreId == state.remote) {
          participant = call.participants[i];
        }
      }

      var updateParticipant = <CallHistoryParticipantModel>[];

      if (participant != null) {
        //* It means someone in call end or reject call
        updateParticipant = call.participants.map((p) {
          if (p.coreId != participant!.coreId) {
            return p;
          } else {
            return participant.copyWith(endDate: DateTime.now());
          }
        }).toList();
      } else {
        //* It means Current user end call
        //* So we should fill all the end dates
        updateParticipant = call.participants.map((p) {
          if (p.endDate == null) {
            return p.copyWith(endDate: DateTime.now());
          } else {
            return p;
          }
        }).toList();
      }

      updateCall = call.copyWith(
        endDate: DateTime.now(),
        participants: updateParticipant,
      );
    }

    await callHistoryRepo.updateCall(updateCall);
  }

  Future<void> _connectedCallHistory({
    required CallHistoryState state,
  }) async {
    final call = await callHistoryRepo.getOneCall(state.callId);
    if (call == null) {
      return;
    }

    final status = call.status == CallStatus.incomingMissed
        ? CallStatus.incomingAnswered
        : CallStatus.outgoingAnswered;

    /// store the time call started
    _callStartTimestamps[state.callId] = DateTime.now();

    //if (call.participants.isNotEmpty) {
    final callWithNewParticipant = await _addParticipantToCallHistory(
      callHistoryModel: call,
      callHistoryState: state,
    );
    //}

    final updateCall = callWithNewParticipant.copyWith(
      status: status,
      //endDate: DateTime.now(),
    );

    await callHistoryRepo.updateCall(updateCall);
  }

  Future<CallHistoryModel> _addParticipantToCallHistory({
    required CallHistoryModel callHistoryModel,
    required CallHistoryState callHistoryState,
  }) async {
    //* Check if the new user save to contact or not
    final callParticipant = await _getUserFromCoreId(
      callHistoryState.remote,
    );

    //* Check if the new user is in call or not
    var isInCall = false;
    var currentParticipantList = [...callHistoryModel.participants];
    for (var i = 0; i < currentParticipantList.length; i++) {
      if (currentParticipantList[i].coreId == callParticipant.coreId) {
        // TODO(AliAzim): update the data.
        //* The user is already in call
        isInCall = true;
      }
    }

    if (!isInCall) {
      currentParticipantList = [
        ...currentParticipantList,
        callParticipant.copyWith(
          status: CallHistoryParticipantStatus.accepted,
        ),
      ];
    } else {
      currentParticipantList
        //* remove the participant from list
        ..removeWhere(
          (element) => element.coreId == callParticipant.coreId,
        )
        //* add participant with accepted status
        ..add(
          callParticipant.copyWith(
            status: CallHistoryParticipantStatus.accepted,
          ),
        );
    }
    final updateCall = callHistoryModel.copyWith(
      participants: currentParticipantList,
    );
    //await callHistoryRepo.updateCall(updateCall);
    return updateCall;
  }

  Future<CallHistoryParticipantModel> _getUserFromCoreId(String coreId) async {
    final contact = await getContactByIdUseCase.execute(coreId);
    CallHistoryParticipantModel callHistoryParticipant;

    if (contact != null) {
      callHistoryParticipant = contact.mapToCallHistoryParticipantModel();
    } else {
      callHistoryParticipant = CallHistoryParticipantModel(
        coreId: coreId,
        startDate: DateTime.now(),
      );
    }

    return callHistoryParticipant;
  }

//CallStatus? _determineCallStatusFromPrevAndHistory(
//  CallStatus prevStatus,
//  CallHistoryStatus historyStatus,
//) {
//if (prevStatus == CallStatus.outgoingNotAnswered //&&
//    /*historyStatus == CallHistoryStatus.byeSent*/) {
//  return CallStatus.outgoingCanceled;
//}

//if (prevStatus == CallStatus.outgoingNotAnswered //&&
//    /* historyStatus == CallHistoryStatus.byeReceived*/) {
//  return CallStatus.outgoingDeclined;
//}

//if (prevStatus == CallStatus.incomingMissed //&&
//    /*historyStatus == CallHistoryStatus.byeSent*/) {
//  return CallStatus.incomingDeclined;
//}

//  if (prevStatus == CallStatus.incomingMissed //&&
//      /* historyStatus == CallHistoryStatus.byeReceived*/) {
//    return CallStatus.incomingMissed;
//  }

//  return null;
//}
}

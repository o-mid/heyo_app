import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/call_status_observer.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class CallHistoryObserver extends GetxController {
  CallHistoryObserver({
    required this.callHistoryRepo,
    required this.callStatusObserver,
    required this.contactRepository,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final CallStatusObserver callStatusObserver;
  final ContactRepository contactRepository;

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
    stateListener =
        callStatusObserver.callHistoryState.listen((state) async {
      if (state == null) {
        return;
      }
      switch (state.callHistoryStatus) {
        case CallHistoryStatus.incoming:
          {
            await _createMissedCallRecord(
              callInfo: state.remote,
              callId: state.callId,
            );
            break;
          }
        case CallHistoryStatus.calling:
          {
            await _createOutgoingNotAnsweredRecord(
              callInfo: state.remote,
              callId: state.callId,
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
            final call = await callHistoryRepo.getOneCall(state.callId);
            if (call == null) {
              return;
            }

            final startTime = _callStartTimestamps[state.callId];

            if (startTime == null) {
              //* This means the user reject the call
              await _endOrRejectCall(
                callId: call.callId,
                status: _determineCallStatusFromPrevAndHistory(
                  call.status,
                  state.callHistoryStatus,
                ),
              );
            } else {
              //* This means the call end after duration
              await _endOrRejectCall(
                callId: call.callId,
              );
            }

            break;
          }

      }
    });
  }

  CallStatus? _determineCallStatusFromPrevAndHistory(
    CallStatus prevStatus,
    CallHistoryStatus historyStatus,
  ) {
    if (prevStatus == CallStatus.outgoingNotAnswered //&&
        /*historyStatus == CallHistoryStatus.byeSent*/) {
      return CallStatus.outgoingCanceled;
    }

    if (prevStatus == CallStatus.outgoingNotAnswered //&&
       /* historyStatus == CallHistoryStatus.byeReceived*/) {
      return CallStatus.outgoingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed //&&
        /*historyStatus == CallHistoryStatus.byeSent*/) {
      return CallStatus.incomingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed //&&
       /* historyStatus == CallHistoryStatus.byeReceived*/) {
      return CallStatus.incomingMissed;
    }

    return null;
  }

  Future<void> _createMissedCallRecord({
    required CallInfo callInfo,
    required String callId,
  }) async {
    final callParticipant = await _getUserFromCoreId(
      callInfo.remotePeer.remoteCoreId,
    );

    final callHistory = CallHistoryModel(
      participants: [callParticipant],
      status: CallStatus.incomingMissed,
      startDate: DateTime.now(),
      callId: callId,
      type: callInfo.isAudioCall ? CallType.audio : CallType.video,
    );

    await callHistoryRepo.addCallToHistory(callHistory);
  }

  Future<void> _createOutgoingNotAnsweredRecord({
    required CallInfo callInfo,
    required String callId,
  }) async {
    final callParticipant = await _getUserFromCoreId(
      callInfo.remotePeer.remoteCoreId,
    );

    final callHistory = CallHistoryModel(
      participants: [callParticipant],
      status: CallStatus.outgoingNotAnswered,
      startDate: DateTime.now(),
      callId: callId,
      type: callInfo.isAudioCall ? CallType.audio : CallType.video,
    );

    await callHistoryRepo.addCallToHistory(callHistory);
  }

  Future<void> _endOrRejectCall({
    required String callId,
    CallStatus? status,
  }) async {
    final call = await callHistoryRepo.getOneCall(callId);
    if (call == null) {
      return;
    }

    final updateCall = status == null
        ? call.copyWith(
            endDate: DateTime.now(),
          )
        : call.copyWith(
            status: status,
            endDate: DateTime.now(),
          );
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

    if (call.participants.isNotEmpty) {
      await _addMemberToCallHistory(
        callHistoryModel: call,
        callHistoryState: state,
      );
    }

    final updateCall = call.copyWith(
      status: status,
      endDate: DateTime.now(),
    );
    await callHistoryRepo.updateCall(updateCall);
  }

  Future<void> _addMemberToCallHistory({
    required CallHistoryModel callHistoryModel,
    required CallHistoryState callHistoryState,
  }) async {
    //* Check if the new user save to contact or not
    final callParticipant = await _getUserFromCoreId(
      callHistoryState.remote.remotePeer.remoteCoreId,
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
    await callHistoryRepo.updateCall(updateCall);
  }

  Future<CallHistoryParticipantModel> _getUserFromCoreId(String coreId) async {
    final user = await contactRepository.getContactById(coreId);
    CallHistoryParticipantModel callHistoryParticipant;

    if (user != null) {
      callHistoryParticipant = user.mapToCallHistoryParticipantModel();
    } else {
      callHistoryParticipant = CallHistoryParticipantModel(
        name: coreId.shortenCoreId,
        coreId: coreId,
        startDate: DateTime.now(),
      );
    }

    return callHistoryParticipant;
  }
}

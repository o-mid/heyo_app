import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
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
    required this.callConnectionController,
    required this.contactRepository,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final CallConnectionController callConnectionController;
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
        callConnectionController.callHistoryState.listen((state) async {
      if (state == null) {
        return;
      }
      switch (state.callHistoryStatus) {
        case CallHistoryStatus.ringing:
          {
            await _createMissedCallRecord(
              callInfo: state.remotes.first,
              callId: state.callId,
            );
            break;
          }
        case CallHistoryStatus.invite:
          {
            await _createOutgoingNotAnsweredRecord(
              callInfo: state.remotes.first,
              callId: state.callId,
            );
            break;
          }
        case CallHistoryStatus.connected:
          {
            final call = await callHistoryRepo
                .getOneCall(state.remotes.first.remotePeer.remoteCoreId);
            if (call == null) {
              return;
            }

            /// store the time call started
            _callStartTimestamps[state.callId] = DateTime.now();

            await _updateCallStatusAndEndTime(
              callId: call.callId,
              status: call.status == CallStatus.incomingMissed
                  ? CallStatus.incomingAnswered
                  : CallStatus.outgoingAnswered,
            );
            break;
          }
        case CallHistoryStatus.byeSent:
        case CallHistoryStatus.byeReceived:
          {
            final call = await callHistoryRepo.getOneCall(state.callId);
            if (call == null) {
              return;
            }

            final startTime = _callStartTimestamps[call.callId];

            if (startTime == null) {
              await _updateCallStatusAndEndTime(
                callId: call.callId,
                status: _determineCallStatusFromPrevAndHistory(
                  call.status,
                  state.callHistoryStatus,
                ),
              );
              return;
            }

            await _updateCallStatusAndEndTime(
              callId: call.callId,
            );
            break;
          }
        case CallHistoryStatus.initial:
        case CallHistoryStatus.nop:
          break;
      }
    });
  }

  CallStatus? _determineCallStatusFromPrevAndHistory(
    CallStatus prevStatus,
    CallHistoryStatus historyStatus,
  ) {
    if (prevStatus == CallStatus.outgoingNotAnswered &&
        historyStatus == CallHistoryStatus.byeSent) {
      return CallStatus.outgoingCanceled;
    }

    if (prevStatus == CallStatus.outgoingNotAnswered &&
        historyStatus == CallHistoryStatus.byeReceived) {
      return CallStatus.outgoingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed &&
        historyStatus == CallHistoryStatus.byeSent) {
      return CallStatus.incomingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed &&
        historyStatus == CallHistoryStatus.byeReceived) {
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
      coreId: callParticipant.coreId,
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
      coreId: callParticipant.coreId,
      type: callInfo.isAudioCall ? CallType.audio : CallType.video,
    );

    await callHistoryRepo.addCallToHistory(callHistory);
  }

  Future<void> _updateCallStatusAndEndTime({
    required String callId,
    CallStatus? status,
  }) async {
    final call = await callHistoryRepo.getOneCall(callId);
    if (call == null) {
      return;
    }
    //TODO:(Aliazim) update model why delete and create !?
    await callHistoryRepo.deleteOneCall(callId);
    //TODO:(Aliazim) change call histoy model
    await callHistoryRepo.addCallToHistory(
      call.copyWith(
        status: status!,
        endDate: DateTime.now(),
      ),
    );
  }

  Future<CallHistoryParticipantModel> _getUserFromCoreId(String coreId) async {
    final user = await contactRepository.getContactById(coreId);
    CallHistoryParticipantModel callHistoryParticipant;

    if (user != null) {
      callHistoryParticipant = user.mapToCallHistoryParticipantModel();
    } else {
      callHistoryParticipant = CallHistoryParticipantModel(
        name: coreId.shortenCoreId,
        iconUrl: 'https://avatars.githubusercontent.com/u/6645136?v=4',
        coreId: coreId,
        startDate: DateTime.now(),
      );
    }

    return callHistoryParticipant;
  }
}

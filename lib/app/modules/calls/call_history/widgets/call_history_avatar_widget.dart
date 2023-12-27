import 'package:flutter/material.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/group_call_circle_avatar.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CallHistoryAvatarWidget extends StatelessWidget {
  const CallHistoryAvatarWidget({required this.callHistoryModel, super.key});
  final CallHistoryModel callHistoryModel;

  @override
  Widget build(BuildContext context) {
    if (callHistoryModel.participants.length == 1) {
      return CustomCircleAvatar(
        coreId: callHistoryModel.participants[0].coreId,
        size: 40,
      );
    } else {
      return GroupCallCircleAvatar(
        participants: callHistoryModel.participants
            .map(
              (e) => e.coreId,
            )
            .toList(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history/widgets/group_call_circle_avatar.dart';

class CallHistoryAvatarWidget extends StatelessWidget {
  const CallHistoryAvatarWidget({required this.callHistoryModel, super.key});
  final CallHistoryViewModel callHistoryModel;

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

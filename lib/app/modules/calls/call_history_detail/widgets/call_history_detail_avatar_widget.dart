import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CallHistoryDetailAvatarWidget extends StatelessWidget {
  const CallHistoryDetailAvatarWidget({required this.participants, super.key});
  final List<String> participants;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List<Widget>.generate(participants.length, (index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(index.toDouble() * 20, 0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: COLORS.kWhiteColor,
                width: 2,
              ),
            ),
            child: CustomCircleAvatar(
              coreId: participants[index],
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}

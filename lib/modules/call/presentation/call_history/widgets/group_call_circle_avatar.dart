import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class GroupCallCircleAvatar extends StatelessWidget {
  const GroupCallCircleAvatar({required this.participants, super.key});
  final List<String> participants;

  //sample.asMap().forEach((index, value) => f(index, value));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: participants
            //* App will show 3 avatar at last so we sublist the first 3
            .sublist(0, participants.length == 2 ? 2 : 3)
            //* We need the index so the list should turn into the map
            .asMap()
            .entries
            .map((p) {
          return Positioned(
            top: p.key == 0 ? 5 : null,
            right: p.key != 0 ? 0 : null,
            bottom: p.key == 2 ? 0 : null,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: COLORS.kWhiteColor,
                  width: 2,
                ),
              ),
              child: CustomCircleAvatar(
                coreId: p.value,
                size: 30 - (p.key * 7),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

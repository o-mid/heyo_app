import 'package:flutter/material.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_renderer_widget.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';

class GroupCallRendererWidget extends StatelessWidget {
  const GroupCallRendererWidget({
    required this.participantModel,
    required this.participantCount,
    super.key,
  });

  final ConnectedParticipantModel participantModel;
  final int participantCount;

  @override
  Widget build(BuildContext context) {
    if (participantCount == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 4,
            child: CallRendererWidget(
              participantModel: participantModel,
            ),
          ),
        ],
      );
    } else {
      return CallRendererWidget(
        participantModel: participantModel,
      );
    }
  }
}

import 'package:flutter/material.dart';

import 'package:heyo/app/modules/calls/incoming_call/controllers/incoming_call_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

class MultipleCallerInfoWidget extends StatelessWidget {
  final List<IncomingCallModel> incomingCallers;

  const MultipleCallerInfoWidget({
    super.key,
    required this.incomingCallers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 5,
        children: incomingCallers.map(
          (caller) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  caller.name,
                  style: TEXTSTYLES.kHeaderLarge.copyWith(
                    color: COLORS.kWhiteColor,
                  ),
                ),
                if (caller.coreId != incomingCallers.last.coreId)
                  Text(
                    ",",
                    style: TEXTSTYLES.kHeaderLarge.copyWith(
                      color: COLORS.kWhiteColor,
                    ),
                  ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

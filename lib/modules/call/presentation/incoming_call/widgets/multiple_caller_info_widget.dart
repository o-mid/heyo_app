import 'package:flutter/material.dart';

import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_model.dart';
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
      child: Text(
        incomingCallers.map((e) => e.name).toList().join(", "),
        style: TEXTSTYLES.kHeaderLarge.copyWith(
          color: COLORS.kWhiteColor,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

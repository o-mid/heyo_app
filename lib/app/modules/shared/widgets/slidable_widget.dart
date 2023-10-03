import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';

class SlidableWidget extends StatelessWidget {
  final Widget child;
  final void Function() onDismissed;
  final Future<bool> Function() confirmDismiss;

  const SlidableWidget({
    super.key,
    required this.child,
    required this.onDismissed,
    required this.confirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Positioned.fill(
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 1,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: COLORS.kStatesErrorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Slidable(
          key: key,
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: onDismissed,
              confirmDismiss: confirmDismiss,
              closeOnCancel: true,
            ),
            children: [
              CustomSlidableAction(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                onPressed: (context) => confirmDismiss(),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                child: Assets.svg.deleteIcon.svg(
                  color: COLORS.kWhiteColor,
                  width: 18.w,
                  height: 18.w,
                ),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

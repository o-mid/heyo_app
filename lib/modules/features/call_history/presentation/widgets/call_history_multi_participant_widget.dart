import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_detail_controller.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/call_history_detail_list_tile_widget.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/multi_participant_header_widget.dart';

class CallHistoryMultiParticipantWidget extends ConsumerWidget {
  const CallHistoryMultiParticipantWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callHistory = ref.watch(callHistoryDetailNotifierProvider);

    return SingleChildScrollView(
      child: callHistory.value!.participants.isEmpty
          ? const SizedBox.shrink()
          : AnimateListWidget(
              children: [
                const MultiParticipantHeaderWidget(),
                SizedBox(height: 40.h),
                Container(color: COLORS.kBrightBlueColor, height: 8.h),
                SizedBox(height: 24.h),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    LocaleKeys.CallHistory_appbar.tr,
                    style: TEXTSTYLES.kLinkSmall
                        .copyWith(color: COLORS.kTextBlueColor),
                  ),
                ),
                CustomSizes.smallSizedBoxHeight,
                ...callHistory.value!.participants.map((participant) {
                  return CallHistoryDetailListTileWidget(
                    coreId: participant.coreId,
                    name: participant.name,
                    trailing: participant.startDate
                        .formattedDifference(participant.endDate),
                  );
                }),
                CustomSizes.mediumSizedBoxHeight,
              ],
            ),
    );
  }
}

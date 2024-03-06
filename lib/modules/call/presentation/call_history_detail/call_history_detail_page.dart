import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/presentation/call_history/widgets/call_history_loading_widget.dart';
import 'package:heyo/modules/call/presentation/call_history_detail/call_history_detail_controller.dart';
import 'package:heyo/modules/call/presentation/call_history_detail/widgets/call_history_multi_participant_widget.dart';
import 'package:heyo/modules/call/presentation/call_history_detail/widgets/call_history_single_participant_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CallHistoryDetailPage extends ConsumerWidget {
  const CallHistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callHistory = ref.watch(callHistoryDetailNotifierProvider);
    final controller = ref.read(callHistoryDetailNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBarWidget(
        backgroundColor: COLORS.kGreenMainColor,
        title: LocaleKeys.CallHistory_callParticipant.tr,
        actions: [
          Obx(() {
            if (callHistory.hasValue) {
              return InkWell(
                onTap: controller.appBarAction,
                child: Container(
                  margin: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
                  child: Assets.svg.verticalMenuIcon.svg(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: callHistory.when(
        data: (data) {
          if (data!.participants.length == 1) {
            return const CallHistorySingleParticipantWidget();
          } else {
            return const CallHistoryMultiParticipantWidget();
          }
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const CallHistoryLoadingWidget(),
      ),
    );
  }
}

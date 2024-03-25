import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/modules/features/call_history/controllers/call_history_detail_controller.dart';
import 'package:heyo/modules/features/call_history/widgets/history_call_log_widget.dart';

class CallHistoryDetailRecentCallWidget extends ConsumerWidget {
  const CallHistoryDetailRecentCallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentCalls = ref.watch(callHistoryDetailRecentCallProvider);

    return recentCalls.when(
      data: (data) => Column(
        children: data
            .map(
              (call) => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: HistoryCallLogWidget(call: call),
              ),
            )
            .toList(),
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: SizedBox.shrink,
    );
  }
}

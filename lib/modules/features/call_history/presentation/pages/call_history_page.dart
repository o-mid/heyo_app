import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/utils.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/connection_status.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/core-ui/widgets/bottom_sheet_widget.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_controller.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/call_history_list_tile_widget.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/call_history_loading_widget.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/empty_call_history_widget.dart';

class CallHistoryPage extends ConsumerWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(callHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(
        title: LocaleKeys.HomePage_navbarItems_calls.tr,
        actions: [
          if (calls.hasValue)
            IconButton(
              splashRadius: 18,
              onPressed: () => bottomSheetWidget(
                context,
                const DeleteAllCallHistoryBottomSheet(),
              ),
              icon: Assets.svg.verticalMenuIcon.svg(),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConnectionStatusWidget(),
          Expanded(
            child: calls.when(
              data: (data) {
                if (data.isEmpty) {
                  return const EmptyCallHistoryWidget();
                } else {
                  return AnimateListWidget(
                    children: data
                        .map((call) => CallHistoryListTitleWidget(call: call))
                        .toList(),
                  );
                }
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const CallHistoryLoadingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

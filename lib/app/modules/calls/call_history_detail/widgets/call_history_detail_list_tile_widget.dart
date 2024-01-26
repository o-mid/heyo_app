import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CallHistoryDetailListTileWidget extends StatelessWidget {
  const CallHistoryDetailListTileWidget({
    required this.coreId,
    required this.name,
    required this.trailing,
    super.key,
  });

  final String coreId;
  final String name;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      leading: CustomCircleAvatar(
        coreId: coreId,
        size: 42,
      ),
      title: Text(name),
      subtitle: Text(coreId.shortenCoreId),
      trailing: Text(trailing),
    );
  }
}

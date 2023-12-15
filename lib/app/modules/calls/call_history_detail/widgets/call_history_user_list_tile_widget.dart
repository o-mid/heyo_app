import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CallHistoryUserListTileWidget extends StatelessWidget {
  const CallHistoryUserListTileWidget({
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
    return Padding(
      padding: EdgeInsets.symmetric(
        //horizontal: 20.w,
        vertical: 8.h,
      ),
      child: ListTile(
        leading: CustomCircleAvatar(
          coreId: coreId,
          size: 42,
        ),
        title: Text(name),
        subtitle: Text(coreId.shortenCoreId),
        trailing: Text(trailing),
      ),
    );
  }
}

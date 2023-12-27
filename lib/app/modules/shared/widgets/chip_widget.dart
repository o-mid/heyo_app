import 'package:core_blockies/core_blockies.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class ChipWidget extends StatelessWidget {
  final String label;
  final String coreId;
  final void Function()? onDelete;
  const ChipWidget({
    super.key,
    required this.label,
    required this.coreId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: COLORS.kChipColor,
      deleteIcon: const Icon(Icons.close),
      avatar:CoreBlockies(coreId: coreId,size: 16,),
      label: Text(label),
      onDeleted: onDelete,
    );
  }
}

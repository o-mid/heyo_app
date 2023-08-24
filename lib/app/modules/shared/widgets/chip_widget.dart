import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class ChipWidget extends StatelessWidget {
  final String avatarUrl;
  final String label;
  final void Function()? onDelete;
  const ChipWidget({
    super.key,
    required this.avatarUrl,
    required this.label,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: COLORS.KChipColor,
      deleteIcon: const Icon(Icons.close),
      avatar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: COLORS.KChatFooterGrey),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(avatarUrl),
          ),
        ),
      ),
      label: Text(label),
      onDeleted: onDelete,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({
    required this.child,
    this.count = 30,
    super.key,
  });

  final Widget child;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ListView.builder(
        itemCount: count,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => child,
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: COLORS.kShimmerBase,
      highlightColor: COLORS.kShimmerHighlight,
      period: const Duration(seconds: 2),
      child: child,
    );
  }
}

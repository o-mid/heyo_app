import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/widgets/shimmer_widget.dart';

class CallHistoryLoadingWidget extends StatelessWidget {
  const CallHistoryLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerListWidget(
      child: CallHistoryLoadingListTitle(),
    );
  }
}

class CallHistoryLoadingListTitle extends StatelessWidget {
  const CallHistoryLoadingListTitle({super.key});

  Widget _loadingTextWidget({required double width, required double height}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(2),
        ),
      ),
      width: width,
      height: height,
    );
  }

  Widget _loadingCircleWidget({required double size}) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      width: size,
      height: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _loadingCircleWidget(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _loadingTextWidget(width: 30, height: 10),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _loadingTextWidget(width: 30, height: 10),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _loadingCircleWidget(size: 35),
        ],
      ),
    );
  }
}

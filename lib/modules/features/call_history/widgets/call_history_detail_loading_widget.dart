import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/shimmer_widget.dart';

class CallHistoryDetailLoadingWidget extends StatelessWidget {
  const CallHistoryDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Column(
        children: [
          const CallHistoryLoadingHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const SingleParticipantListTileLoading();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CallHistoryLoadingHeader extends StatelessWidget {
  const CallHistoryLoadingHeader({super.key});

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
      child: Column(
        children: [
          SizedBox(height: 40.h),
          _loadingCircleWidget(size: 64),
          CustomSizes.mediumSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loadingTextWidget(width: 100, height: 10),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loadingTextWidget(width: 60, height: 8),
            ],
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loadingCircleWidget(size: 48),
              SizedBox(width: 24.w),
              _loadingCircleWidget(size: 48),
              SizedBox(width: 24.w),
              _loadingCircleWidget(size: 48),
            ],
          ),
          SizedBox(height: 40.h),
          Container(color: Colors.white, height: 8.h),
          SizedBox(height: 24.h),
          Row(
            children: [
              _loadingTextWidget(width: 40, height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleParticipantListTileLoading extends StatelessWidget {
  const SingleParticipantListTileLoading({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _loadingTextWidget(width: double.infinity, height: 10),
              ),
              const Spacer(flex: 2),
              _loadingTextWidget(width: 30, height: 10),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _loadingTextWidget(width: double.infinity, height: 10),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

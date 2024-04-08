import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/shimmer_widget.dart';

class ContactsLoadingWidget extends StatelessWidget {
  const ContactsLoadingWidget({super.key});

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
    return ShimmerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CustomSizes.largeSizedBoxHeight,
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      padding: EdgeInsets.all(12.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _loadingTextWidget(height: 10, width: 60),
                        ],
                      ),
                    ),
                    _loadingTextWidget(height: 10, width: 20),
                  ],
                ),
              ),
            ],
          ),
          const Divider(thickness: 8, color: Colors.white),
          CustomSizes.largeSizedBoxHeight,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _loadingTextWidget(width: 50, height: 10),
          ),
          CustomSizes.smallSizedBoxHeight,
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const ContactLoadingWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContactLoadingWidget extends StatelessWidget {
  const ContactLoadingWidget({super.key});

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _loadingCircleWidget(size: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _loadingTextWidget(
                        width: double.infinity,
                        height: 10,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _loadingTextWidget(
                        width: double.infinity,
                        height: 10,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          _loadingCircleWidget(size: 40),
          const SizedBox(width: 8),
          _loadingCircleWidget(size: 40),
        ],
      ),
    );
  }
}

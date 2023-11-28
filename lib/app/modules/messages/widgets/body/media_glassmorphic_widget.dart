import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../../../../routes/app_pages.dart';
import '../../../shared/utils/constants/colors.dart';
import '../../../shared/utils/constants/textStyles.dart';
import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../shared/widgets/circular_media_icon_button.dart';
import '../../controllers/messages_controller.dart';

class MediaGlassmorphicWidget extends StatelessWidget {
  const MediaGlassmorphicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 50),
        reverseDuration: const Duration(milliseconds: 150),
        child: controller.isMediaGlassmorphicOpen.value ? _buildMediaContainer() : const SizedBox(),
      );
    });
  }

  Widget _buildMediaContainer() {
    return GlassmorphicContainer(
      width: 290.w,
      height: 156.h,
      borderRadius: 8.r,
      blur: 36,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF466087).withOpacity(0.05),
          const Color(0xFF466087).withOpacity(0.05),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMediaRow([
            _buildMediaButton(
              backgroundColor: const Color(0xffFFB500),
              icon: Assets.svg.cameraIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => _showDevelopmentSnackbar("Sending Media feature"),
            ),
            _buildMediaButton(
              backgroundColor: const Color(0xff16B4F2),
              icon: Assets.svg.galleryIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => _showDevelopmentSnackbar("Sending Media feature"),
            ),
            _buildMediaButton(
              backgroundColor: const Color(0xff7E3CF9),
              icon: Assets.svg.locationIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => Get.toNamed(Routes.SHARE_LOCATION),
            ),
          ]),
          _buildMediaRow([
            _buildMediaButton(
              backgroundColor: const Color(0xffF93C53),
              icon: Assets.svg.fileIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => _showDevelopmentSnackbar("Sending Files feature"),
            ),
            _buildMediaButton(
              backgroundColor: const Color(0xff00B4B5),
              icon: Assets.svg.moneyIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => _showDevelopmentSnackbar("Sending Money feature"),
            ),
            _buildMediaButton(
              backgroundColor: const Color(0xff003EB5),
              icon: Assets.svg.personIcon.svg(height: 20.w, width: 20.w),
              onPressed: () => _showDevelopmentSnackbar("Account Sharing feature"),
            ),
          ]),
        ],
      ),
    );
  }

  Row _buildMediaRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  CircularMediaIconButton _buildMediaButton({
    required Color backgroundColor,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return CircularMediaIconButton(
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      padding: 18,
      child: icon,
    );
  }

  void _showDevelopmentSnackbar(String featureName) {
    Get.rawSnackbar(
      messageText: Text(
        "$featureName is in development phase",
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kGreenMainColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: COLORS.kAppBackground,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(top: 20),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF466087).withOpacity(0.1),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ],
      borderRadius: 8,
    );
  }
}

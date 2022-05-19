import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/bordered_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCopyrightOSMWidget extends StatelessWidget {
  const CustomCopyrightOSMWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse('https://www.openstreetmap.org/copyright');
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      child: BorderedText(
        strokeWidth: 2,
        strokeColor: COLORS.kWhiteColor,
        child: Text(
          "© OpenStreetMap",
          style: TEXTSTYLES.kChatText.copyWith(
            fontWeight: FONTS.Bold,
            color: COLORS.kOSMCopyrightText,
          ),
        ),
      ),
    );
  }
}

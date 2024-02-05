import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../../shared/widgets/list_header_widget.dart';
import '../controllers/forward_massages_controller.dart';

class ContactsWidget extends StatelessWidget {
  ContactsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForwardMassagesController>();
    return Column(
      children: [
        Obx(() => Expanded(
              child: ListView.builder(
                itemCount: controller.searchSuggestions.length,
                itemBuilder: (context, index) {
                  final user = controller.searchSuggestions[index];
                  bool showHeader = index == 0 ||
                      controller.searchSuggestions[index - 1].name[0].toUpperCase() !=
                          user.name[0].toUpperCase();

                  return Column(
                    children: [
                      if (showHeader) ListHeaderWidget(title: user.name[0].toUpperCase()),
                      InkWell(
                        onTap: () => controller.setSelectedUser(
                          user.coreId,
                        ),
                        child: UserWidget(
                          coreId: user.coreId,
                          name: user.name,
                          walletAddress: user.walletAddress,
                          isOnline: user.isOnline,
                          isVerified: user.isVerified,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../contacts/widgets/removeContactsDialog.dart';
import '../../shared/data/models/add_contacts_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/constants/transitions_constant.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';
import '../widgets/user_preview_widget.dart';

class UserPreview extends GetxController {
  final ContactRepository contactRepository;
  final RxBool isWifiDirectConnection = false.obs;

  UserPreview({required this.contactRepository});

  Future<void> openUserPreview({
    bool isWifiDirect = false,
    required UserModel userModel,
  }) async {
    userModel;

    isWifiDirectConnection.value = isWifiDirect;
    print("openUserPreviewBottomSheet");

    Get.bottomSheet(
      enterBottomSheetDuration: TRANSITIONS.newChat_EnterBottomSheetDuration,
      exitBottomSheetDuration: TRANSITIONS.newChat_ExitBottomSheetDuration,
      UserPreviewWidget(user: userModel),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Future<void> deleteContact(String userCoreId) async {
    await contactRepository
        .deleteContactById(
          userCoreId,
        )
        .then((value) => print("object deleted  $value "));
  }
}

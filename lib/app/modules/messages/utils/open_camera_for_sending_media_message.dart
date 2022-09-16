import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:heyo/app/modules/messages/widgets/body/camera_picker/receiver_name_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/gallery_preview_button_widget.dart';
import 'package:heyo/generated/assets.gen.dart';

typedef EntitySaveCallback = FutureOr<dynamic> Function(
  CameraPickerViewType viewType,
  File file,
);

Future<void> openCameraForSendingMediaMessage(
  BuildContext context, {
  EntitySaveCallback? onEntitySaving,
  required String receiverName,
}) async {
  try {
    await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        textDelegate: EnglishCameraPickerTextDelegate(),
        sendIcon: Assets.svg.sendIcon.svg(),
        receiverNameWidget: ReceiverNameWidget(name: receiverName),
        additionalPreviewButtonWidget: const GalleryPreviewButtonWidget(),
        inputTextStyle: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
        previewTextInputDecoration: InputDecoration(
          hintText: 'Type something',
          hintStyle: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
        ),
        onEntitySaving: onEntitySaving == null
            ? null
            : (_, viewType, file, __) => onEntitySaving(viewType, file),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

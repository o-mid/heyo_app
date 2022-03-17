import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      /// about ```translationsKeys``` see the Getx package on internationalization https://pub.dev/packages/get#internationalization
      // translationsKeys: AppTranslation.translations,
      title: 'Flutter app structure',
      theme: ThemeData(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale(
        'en',
        'EN',
      ),
      builder: (context, child) {
        /// we use this widget to have global overlay over the app, like a global loading. etc
        return Container(child: child);
      },

      /// we use this for any use of Controllers that need to be put in the ```Get``` state manager and live through the life cycle of the application.
      //initialBinding: GlobalBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

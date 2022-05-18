import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';

void main() {
  runApp(
    ScreenUtilInit(
      //  Width and height from figma design
      designSize: const Size(375, 712),

      builder: (_, __) => GetMaterialApp(
        /// about ```translationsKeys``` see the Getx package on internationalization https://pub.dev/packages/get#internationalization
        // translationsKeys: AppTranslation.translations,
        title: 'Flutter app structure',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        locale: const Locale("en", "EN"),
        fallbackLocale: const Locale(
          'en',
          'EN',
        ),

        translationsKeys: AppTranslation.translations,
        builder: (context, child) {
          /// we use this widget to have global overlay over the app, like a global loading. etc
          return Container(child: child);
        },

        /// we use this for any use of Controllers that need to be put in the ```Get``` state manager and live through the life cycle of the application.
        initialBinding: GlobalBindings(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}

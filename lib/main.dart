import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/modules/shared/utils/constants/strings_constant.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // only activate sentry in release mode
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = Platform.isAndroid ? SENTRY_ANDROID_DNS : SENTRY_IOS_DNS
          ..sendDefaultPii = true
          ..tracesSampleRate = 0;
      },
      appRunner: () => initApp(),
    );
  } else {
    initApp();
  }
}

void initApp() {
  runApp(
    ScreenUtilInit(
      //  Width and height from figma design
      designSize: const Size(375, 712),

      builder: (_, child) => GetMaterialApp(
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],

        /// about ```translationsKeys``` see the Getx package on internationalization https://pub.dev/packages/get#internationalization
        // translationsKeys: AppTranslation.translations,
        title: 'Heyo',
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

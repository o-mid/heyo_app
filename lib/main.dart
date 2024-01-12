import 'dart:convert';
import 'dart:io';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:heyo/app/modules/calls/data/notification_processor.dart';

import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/modules/shared/utils/constants/strings_constant.dart';
import 'firebase_options.dart';
import 'app/modules/calls/data/call_background_request.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  notificationSetup();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  FirebaseMessaging.onMessage.listen(
    (data) => onMessageReceived(
      data,
      isFromBackground: false,
      flutterLocalNotification: flutterLocalNotificationsPlugin,
    ),
  );
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

void notificationSetup() {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettingsDarwin = DarwinInitializationSettings(
    notificationCategories: [
      DarwinNotificationCategory(
        'Calls',
        actions: [
          DarwinNotificationAction.plain('1', 'Accept',
              options: {DarwinNotificationActionOption.foreground}),
          DarwinNotificationAction.plain('2', 'Deny',
              options: {DarwinNotificationActionOption.foreground}),
        ],
      ),
    ],
  );
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    onDidReceiveNotificationResponse: (notification) async {
      /// user pressed first action button, means agreeing to proceed
      if (notification.id! == 1) {
        //TODO should be refactored and notification should be updated based on the time
        NotificationProcessor.process(
          null,
          notification.payload!,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          isBackgroundNotification: false,
        );
      }
    },
  );
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

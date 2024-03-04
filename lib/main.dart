import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/initial_bindings.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/data/notification_processor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'modules/call/data/call_background_request.dart';
import 'app/modules/shared/utils/constants/strings_constant.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  InitialBindings().dependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  firebaseSetup();
  localNotificationSetup();

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

void firebaseSetup() {
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  FirebaseMessaging.onMessage.listen(
    (data) => onMessageReceived(
      data,
      isFromBackground: false,
      flutterLocalNotification: flutterLocalNotificationsPlugin,
    ),
  );
}

void localNotificationSetup() {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettingsDarwin = DarwinInitializationSettings(
    notificationCategories: [
      DarwinNotificationCategory(
        'Calls',
        actions: [
          DarwinNotificationAction.plain(
            '1',
            'Accept',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            '2',
            'Deny',
            options: {DarwinNotificationActionOption.foreground},
          ),
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
    onDidReceiveNotificationResponse: (notification) async {
      NotificationProcessor.process(
        null,
        notification.payload!,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        isBackgroundNotification: false,
      );
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
        theme: ThemeData(useMaterial3: false),
        locale: const Locale('en', 'EN'),
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

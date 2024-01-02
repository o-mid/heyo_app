
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heyo/firebase_options.dart';

Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  print("_onBackgroundMessageReceived ${message.data}");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:panimithra/src/utilities/notification_service/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // required
  NotificationInitService().initialize(); // in background isolate
  NotificationInitService().createNotification(
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      "");
  // Shared logic: e.g., write to Hive or show notification
  print('📬 Background message received: ${message.messageId}');
  print('background data: ${message.data}');
  print('message title: ${message.notification!.title.toString()}');
  print('message body: ${message.notification!.body}');
}

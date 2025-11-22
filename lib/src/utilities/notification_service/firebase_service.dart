import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:panimithra/src/utilities/notification_service/notification_service.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void initialize() {
    print("init called");
    requestPermission();
    getToken();
    setupForegroundMessageListener();
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    // Ask for notification permissions (iOS, macOS, Web, Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        print('✅ Fully authorized!');
        break;
      case AuthorizationStatus.provisional:
        print('🟡 Provisional permission on iOS/macOS');
        break;
      case AuthorizationStatus.denied:
        print('❌ Permission denied – prompt to settings');
        break;
      case AuthorizationStatus.notDetermined:
        print('🕒 Permission not determined yet');
        break;
    }
  }

  getToken() async {
    String? token = await _messaging.getToken();
    return token;
  }

  void setupForegroundMessageListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationInitService().initialize();
      NotificationInitService().createNotification(
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          "");
      //Trigger notification here
    });
  }
}

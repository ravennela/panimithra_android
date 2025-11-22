import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationInitService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  void initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  @pragma('vm:entry-point')
  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle tap or action here
    print('Notification tapped: ${response.payload}');
    // Navigate or perform an action...
  }

  void createNotification(String title, String body, String bigPicture) async {
    final androidDetails = AndroidNotificationDetails(
      'basic_channel', // channel id
      'Basic notifications', // channel name
      channelDescription: 'Basic tests',
      importance: Importance.max,
      priority: Priority.max,
    );

    final iosDetails = DarwinNotificationDetails();
    final notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    print("show details");
    await _plugin.show(
      10,
      title,
      body,
      notifDetails,
      payload: 'custom_payload',
    );
  }
}

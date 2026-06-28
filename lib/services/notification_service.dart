import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need to initialize other Firebase services or local databases here,
  // ensure you call Firebase.initializeApp() first.
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request permissions for iOS and Android 13+
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // 2. Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Get FCM Token (Useful for targeted server-to-device messages)
    try {
      final token = await _messaging.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Failed to get FCM token: $e');
    }

    // 4. Handle token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
    });

    // 5. Subscribe to topic
    await subscribeToTopic('new_emails');
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }
}

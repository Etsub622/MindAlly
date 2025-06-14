import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

// Background handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message received: ${message.messageId}");
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(GoRouter router) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground message received: ${message.data}");
      decodeNotification(router, message);
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("App opened from notification: ${message.data}");
      decodeNotification(router, message);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _sendFcmTokenToBackend();
  }

  void decodeNotification(GoRouter router, RemoteMessage message) {
    if (message.data.containsKey("notificationType") &&
        message.data["notificationType"] == "new_message") {
      debugPrint("Navigating to ChatRoom via notification");
      router.go(
          '/chat'); 
    }
  }

Future<void> showNotification(RemoteMessage msg) async {
    if (msg.notification == null || msg.data.isEmpty) return;

    // Get the current user's ID
    String? currentUserId = await _getUserId();
    String? senderId = msg.data['senderId']; 

    // Only show notification if the current user is not the sender
    if (currentUserId != null &&
        senderId != null &&
        currentUserId != senderId) {
      const androidChannelSpecifics = AndroidNotificationDetails(
        "chat_notifications",
        "Chat Notifications",
        channelDescription: "Notifications for new chat messages",
        importance: Importance.high,
        priority: Priority.high,
      );
      const platformChannelSpecifics =
          NotificationDetails(android: androidChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        msg.notification?.title ?? "New Message",
        msg.notification?.body ?? "You have a new message",
        platformChannelSpecifics,
        payload: json.encode(msg.data),
      );
    } else {
      debugPrint("Notification skipped: User is the sender.");
    }
  }

  Future<void> _sendFcmTokenToBackend() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken == null) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token_key');
      String? userId = await _getUserId();
      print('token:$authToken');
      print(json.encode({'userId': userId, 'token': fcmToken}));
      if (authToken != null && userId != null) {
        final response = await http.post(
          Uri.parse('${ConfigKey.baseUrl}/notifications/save-token'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({'userId': userId, 'token': fcmToken}),
        );
        print('FCM token sent: $fcmToken');
        print('User ID: $userId');
        print('Response body: ${response.body}');
        print('Response headers: ${response.headers}');
        print('Response status: ${response.statusCode}');
        if (response.statusCode != 200) {
          debugPrint('Failed to send FCM token: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error sending FCM token: $e');
    }
  }

  Future<String?> _getUserId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token_key") ?? '';
      print('tokennnnn: $token');
      if (token.isEmpty) return null;

      Map<String, dynamic> payload = JwtDecoder.decode(token);
      String userId = payload['id'];
      return userId;
    } catch (e) {
      debugPrint("Error decoding token: $e");
      return null;
    }
  }
}

// Optional NotificationWrapper (only if used separately)
class NotificationWrapper extends StatefulWidget {
  const NotificationWrapper({super.key});

  @override
  _NotificationWrapperState createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> {
  final PushNotificationService _notificationService =
      PushNotificationService();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = routerConfig();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.initialize(_router);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

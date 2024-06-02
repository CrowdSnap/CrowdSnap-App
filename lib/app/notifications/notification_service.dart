import 'package:crowd_snap/app/router/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@riverpod
class NotificationService extends _$NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  @override
  void build() {
    // Este método se llama cuando el proveedor se inicializa.
    // Puedes realizar cualquier configuración inicial aquí.
    _initialize();
  }

  void _initialize() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message.notification!, message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_crowdsnap_notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void _showNotification(RemoteNotification notification, Map<String, dynamic> data) async {
    final String channelId = data['channel_id'] ?? 'default_channel_id';
    final String channelName = data['channel_name'] ?? 'Default Channel';
    final String channelDescription = data['channel_description'] ?? 'Default Description';

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: data['userId'], // Pass the userId as payload
    );
  }

  void _handleNotificationClick(RemoteMessage message) {
    final userId = message.data['userId'];
    final extra = {
      'username': message.data['username'],
      'avatarUrl': message.data['avatarUrl'],
      'blurHashImage': message.data['blurHashImage'],
    };
    ref.read(appRouterProvider).go('/users/$userId', extra: extra);
  }
}
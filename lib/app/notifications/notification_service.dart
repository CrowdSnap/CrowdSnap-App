import 'package:crowd_snap/app/router/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@riverpod
class NotificationService extends _$NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  @override
  void build() {
    _initialize();
  }

  void _initialize() {
    _requestPermission();
    _initializeLocalNotifications();
    _setupForegroundNotificationListener();
    _setupBackgroundNotificationHandler();
    _setupNotificationClickHandler();
  }

  void _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_crowdsnap_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void _setupForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification?.title ?? 'No Title'}');

      if (message.notification != null) {
        _showNotification(message.notification!, message.data);
      }
    });
  }

  void _setupBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _setupNotificationClickHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification?.title ?? 'No Title'}');
      _handleNotificationClick(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });
  }

  void _showNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    final String channelId = data['channel_id'] ?? 'default_channel_id';
    final String channelName = data['channel_name'] ?? 'Default Channel';
    final String channelDescription =
        data['channel_description'] ?? 'Default Description';

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
      'username': message.data['username'] ?? '',
      'avatarUrl': message.data['avatarUrl'] ?? '',
      'blurHashImage': message.data['blurHashImage'] ?? '',
    };

    // Asegúrate de que todos los valores en 'extra' sean Strings
    final extraString =
        extra.map((key, value) => MapEntry(key, value.toString()));

    print('User ID: $userId');
    print('Extra: $extraString');
    ref.read(appRouterProvider).go('/users/$userId', extra: extraString);
  }

  void _handleNotificationClickFromPayload(String payload) {
    final userId = payload;
    // Aquí puedes agregar lógica adicional si es necesario
    ref.read(appRouterProvider).go('/users/$userId');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      'Handling a background message: ${message.notification?.title ?? 'No Title'}');
}
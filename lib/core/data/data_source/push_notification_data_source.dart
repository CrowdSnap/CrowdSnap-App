import 'dart:convert';

import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_data_source.g.dart';

abstract class PushNotificationDataSource {
  Future<void> sendPushNotification(PushNotificationModel pushNotification);
  Future<void> sendPushNotifications(
      List<String> usersIds, PushNotificationModel pushNotification);
  Future<void> loadEnvVariables();
}

@Riverpod(keepAlive: true)
PushNotificationDataSource pushNotificationDataSource(
    PushNotificationDataSourceRef ref) {
  return PushNotificationDataSourceImpl();
}

class PushNotificationDataSourceImpl implements PushNotificationDataSource {
  final dio = Dio();

  String? _pushNotificationsUrl;

  PushNotificationDataSourceImpl();

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _pushNotificationsUrl = dotenv.env['PUSH_NOTIFICATION_URL'];
  }

  @override
  Future<void> sendPushNotification(
      PushNotificationModel pushNotification) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final data = {
      'token': pushNotification.fcmToken,
      'title': pushNotification.title,
      'body': pushNotification.body,
      'img': pushNotification.imageUrl,
      'userId': pushNotification.userId,
      'username': pushNotification.username,
      'avatarUrl': pushNotification.avatarUrl,
      'blurHashImage': pushNotification.blurHashImage,
    };

    final response = await dio.post(
      _pushNotificationsUrl!,
      options: Options(headers: headers),
      data: data,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send push notification');
    }
  }

  @override
  Future<void> sendPushNotifications(
      List<String> usersIds, PushNotificationModel pushNotification) async {
    var headers = {'Content-Type': 'application/json'};

    for (String userId in usersIds) {
      var data = json.encode({
        'userIds': [userId],
        'title': pushNotification.title,
        'body': pushNotification.body,
        'img': pushNotification.imageUrl,
        'userId': pushNotification.userId,
        'username': pushNotification.username,
        'avatarUrl': pushNotification.avatarUrl,
        'blurHashImage': pushNotification.blurHashImage,
      });

      var response = await dio.request(
        'https://push-notifications.crowdsnap.app/send-notifications?Content-Type=application/json',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
    }
  }
}

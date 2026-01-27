import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/launcher_icon', 
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Not Hatırlatıcıları',
          channelDescription: 'Notlarınız için hatırlatıcı bildirimleri',
          defaultColor: Colors.deepPurpleAccent,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          icon: 'resource://drawable/launcher_icon',
        )
      ],
      debug: true,
    );

await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
});
  }

 static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        icon: 'resource://mipmap/launcher_icon',
        notificationLayout: NotificationLayout.BigPicture, 
        largeIcon: 'asset://assets/icons/icon_app.jpg',
        backgroundColor: const Color(0xFF1D71BA), 
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduledDate,
        preciseAlarm: true, 
        allowWhileIdle: true, 
      ),
    );
  }
}
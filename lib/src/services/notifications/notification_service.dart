import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> setDailyNotificationAtTime(
      DateTime dateTime, NotificationInformation notificationInformation,
      {ChannelInformation channelInformation, int id}) async {
    final Time time = Time(dateTime.hour, dateTime.minute);
    final AndroidNotificationDetails androidPlatformSpecifics =
        AndroidNotificationDetails(channelInformation.id,
            channelInformation.name, channelInformation.description);
    final IOSNotificationDetails iOSPlatformSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(androidPlatformSpecifics, iOSPlatformSpecifics);
    await _getInstance().showDailyAtTime(0, notificationInformation.title,
        notificationInformation.body, time, platformChannelSpecifics);
    return;
  }

  Future<void> cancelNotificationById(int id) {
    return _getInstance().cancel(id);
  }

  Future<void> cancelAllNotifications() {
    return _getInstance().cancelAll();
  }

  FlutterLocalNotificationsPlugin _getInstance() {
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    return _flutterLocalNotificationsPlugin;
  }

  static Future<dynamic> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // TODO(sdstolworthy): implement local notification handling
    print('got local notif');
  }

  static Future<dynamic> onSelectNotification(String payload) async {
    // TODO(sdstolworthy): Implement select notification
    print('selected notification');
  }

  void initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('transparent');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const InitializationSettings initializationSettings =
        InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
    _getInstance().initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void displaySingleNotification(
      {String payload,
      NotificationInformation notificationInformation,
      ChannelInformation channelInformation}) {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelInformation.id,
            channelInformation.name, channelInformation.description,
            importance: Importance.Max, priority: Priority.High);

    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    _getInstance().show(0, notificationInformation.title,
        notificationInformation.body, platformChannelSpecifics,
        payload: payload);
  }
}

class NotificationInformation {
  NotificationInformation({this.title, this.body, this.payload});

  final String body;
  final String payload;
  final String title;
}

class ChannelInformation {
  const ChannelInformation({this.id, this.name, this.description});

  final String description;
  final String id;
  final String name;
}

const ChannelInformation dailyJournalingReminder = ChannelInformation(
    description: 'A daily prompt to write down what you are grateful for.',
    name: 'Daily writing prompt',
    id: 'grateful_daily_journaling_reminder');

abstract class NotificationTypes {
  static const int dailyNotification = 0;
  static const int singleNotification = 1;
}

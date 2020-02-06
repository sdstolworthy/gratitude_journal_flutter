import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  void setDailyNotificationAtTime(
      DateTime dateTime, NotificationInformation notificationInformation,
      {ChannelInformation channelInformation, int id}) async {
    final time = Time(dateTime.hour, dateTime.minute);
    final androidPlatformSpecifics = new AndroidNotificationDetails(
        channelInformation.id,
        channelInformation.name,
        channelInformation.description);
    final iOSPlatformSpecifics = new IOSNotificationDetails();
    final platformChannelSpecifics =
        new NotificationDetails(androidPlatformSpecifics, iOSPlatformSpecifics);
    await _getInstance().showDailyAtTime(0, notificationInformation.title,
        notificationInformation.body, time, platformChannelSpecifics);
  }

  Future<void> cancelNotificationById(int id) {
    return _getInstance().cancel(id);
  }

  Future<void> cancelAllNotifications() {
    return _getInstance().cancelAll();
  }

  FlutterLocalNotificationsPlugin _getInstance() {
    if (_flutterLocalNotificationsPlugin == null) {
      _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    }
    return _flutterLocalNotificationsPlugin;
  }

  static Future<dynamic> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // TODO: implement local notification handling
    print('got local notif');
  }

  static Future<dynamic> onSelectNotification(String payload) async {
    // TODO: Implement select notification
    print('selected notification');
  }

  void initialize() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('transparent');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    this._getInstance().initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void displaySingleNotification(
      {String payload,
      NotificationInformation notificationInformation,
      ChannelInformation channelInformation}) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelInformation.id,
        channelInformation.name,
        channelInformation.description,
        importance: Importance.Max,
        priority: Priority.High);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
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

const dailyJournalingReminder = const ChannelInformation(
    description: 'A daily prompt to write down what you are grateful for.',
    name: 'Daily writing prompt',
    id: 'grateful_daily_journaling_reminder');

abstract class NotificationTypes {
  static final int dailyNotification = 0;
  static final int singleNotification = 1;
}

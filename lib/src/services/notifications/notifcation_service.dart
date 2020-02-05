import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final channelId = 'grateful_daily_notifications';
  final channelName = 'Grateful Daily Notifications';
  final channelDescription =
      'A daily reminder to write down what you are grateful for.';
  void setDailyNotificationAtTime(DateTime dateTime) async {
    _getInstance().cancelAll();
    final time = Time(dateTime.hour, dateTime.minute);
    final androidPlatformSpecifics = new AndroidNotificationDetails(
        channelId, channelName, channelDescription);
    final iOSPlatformSpecifics = new IOSNotificationDetails();
    final platformChannelSpecifics =
        new NotificationDetails(androidPlatformSpecifics, iOSPlatformSpecifics);
    await _getInstance().showDailyAtTime(
        0, channelName, channelDescription, time, platformChannelSpecifics);
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

  void displayNotification() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    _getInstance().show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}

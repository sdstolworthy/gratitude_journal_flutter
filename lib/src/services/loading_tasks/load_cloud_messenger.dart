import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grateful/src/repositories/cloud_messaging/cloud_messaging_repository.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/messaging.dart';

class InitializeCloudMessaging extends LoadingTask {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  InitializeCloudMessaging() : super('Initializing Push Notifications');
  Future<void> execute() async {
    await _firebaseMessaging.requestNotificationPermissions();
    try {
      await _firebaseMessaging
          .getToken()
          .then(CloudMessagingRepository().setId);

      _firebaseMessaging.configure(
          onMessage: (message) async {
            print(message);
          },
          onBackgroundMessage: backgroundMessageHandler,
          onLaunch: (m) async {
            print(m);
          },
          onResume: (m) async {
            print(m);
          });
    } catch (e) {
      print(
          'Failed to configure Firebase Cloud Messaging. Are you using the iOS simulator?');
    }
    return Future.delayed(Duration.zero);
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grateful/src/repositories/cloud_messaging/cloud_messaging_repository.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/messaging.dart';

class InitializeCloudMessaging extends LoadingTask {
  InitializeCloudMessaging() : super('Initializing Push Notifications');

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Future<void> execute() async {
    await _firebaseMessaging.requestNotificationPermissions();
    try {
      await _firebaseMessaging
          .getToken()
          .then(CloudMessagingRepository().setId);

      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print(message);
          },
          onBackgroundMessage: backgroundMessageHandler,
          onLaunch: (Map<String, dynamic> m) async {
            print(m);
          },
          onResume: (Map<String, dynamic> m) async {
            print(m);
          });
    } catch (e) {
      print(
          'Failed to configure Firebase Cloud Messaging. Are you using the iOS simulator?');
    }
    return Future<void>.delayed(Duration.zero);
  }
}

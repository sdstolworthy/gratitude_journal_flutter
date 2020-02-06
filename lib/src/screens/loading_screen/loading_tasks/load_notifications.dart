import 'package:grateful/src/screens/loading_screen/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/notifications/notification_service.dart';

class LoadNotifications extends LoadingTask {
  LoadNotifications() : super('Loading Notifications');

  @override
  Future<void> execute() async {
    NotificationService().initialize();
    return null;
  }
}

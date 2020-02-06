import 'package:flutter/material.dart';
import 'package:grateful/src/services/loading_tasks/load_cloud_messenger.dart';
import 'package:grateful/src/services/loading_tasks/load_journal_feed.dart';
import 'package:grateful/src/services/loading_tasks/load_notifications.dart';
import 'package:grateful/src/services/loading_tasks/load_user_preferences.dart';

abstract class LoadingTask {
  Future<void> execute();

  final String loadingText;
  LoadingTask(this.loadingText);
}

List<LoadingTask> getPreAuthenticationHooks() {
  return [InitializeCloudMessaging(), LoadNotifications()];
}

List<LoadingTask> getPostAuthenticationHooks(BuildContext context) {
  return [LoadJournalFeed(context), LoadUserPreferences(context)];
}

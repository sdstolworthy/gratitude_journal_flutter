import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';

class LoadJournalFeed extends LoadingTask {
  LoadJournalFeed(this.context) : super('Loading Journal Feed');

  BuildContext context;

  @override
  Future<void> execute() {
    BlocProvider.of<JournalFeedBloc>(context).add(FetchFeed());
    return Future<void>.delayed(Duration.zero);
  }
}

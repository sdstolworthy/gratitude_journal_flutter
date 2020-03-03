import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grateful/src/blocs/edit_journal_entry/edit_journal_entry_bloc.dart';
import 'package:grateful/src/blocs/journal_feed/journal_feed_bloc.dart';
import 'package:grateful/src/repositories/analytics/analytics_repository.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:grateful/src/screens/compose_entry/compose_entry.dart';

import 'screen_wrapper.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('Journal Entry Screen renders', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(ScreenWrapper(
      child: BlocProvider<JournalFeedBloc>(
        create: (BuildContext context) =>
            JournalFeedBloc(journalEntryRepository: JournalEntryRepository()),
        child: BlocProvider<EditJournalEntryBloc>(
          create: (BuildContext context) => EditJournalEntryBloc(
              journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context),
              analyticsRepository: AnalyticsRepository()),
          child: ComposeEntry(
            onSave: () {},
          ),
        ),
      ),
    ));
  });
}

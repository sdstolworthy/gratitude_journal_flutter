import 'package:grateful/src/models/journal_entry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class JournalFeedState {}

class JournalFeedUnloaded extends JournalFeedState {}

class JournalFeedFetched extends JournalFeedState {
  JournalFeedFetched(this.journalEntries);

  final List<JournalEntry> journalEntries;
}

class JournalFeedFetchError extends JournalFeedState {}

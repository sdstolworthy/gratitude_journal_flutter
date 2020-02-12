import 'package:grateful/src/models/journal_entry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditJournalEntryEvent {}

class SaveJournalEntry extends EditJournalEntryEvent {
  SaveJournalEntry(this.journalEntry);

  final JournalEntry journalEntry;
}

class DeleteJournalEntry extends EditJournalEntryEvent {
  DeleteJournalEntry(this.journalEntry);

  final JournalEntry journalEntry;
}

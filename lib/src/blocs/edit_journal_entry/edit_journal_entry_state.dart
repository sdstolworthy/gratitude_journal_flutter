import 'package:grateful/src/models/journal_entry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditJournalEntryState {}

class InitialEdititemState extends EditJournalEntryState {}

class ItemLoaded extends EditJournalEntryState {
  ItemLoaded(this.item);

  final JournalEntry item;
}

class JournalEntrySaved extends EditJournalEntryState {
  JournalEntrySaved(this.item);

  final JournalEntry item;
}

class JournalEntryLoading extends EditJournalEntryState {}

class JournalEntrySaveError extends EditJournalEntryState {}

class JournalEntryDeleted extends EditJournalEntryState {}

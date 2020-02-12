import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:grateful/src/repositories/analytics/analytics_repository.dart';
import './bloc.dart';

class EditJournalEntryBloc
    extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  EditJournalEntryBloc(
      {JournalEntryRepository journalEntryRepository,
      @required JournalFeedBloc journalFeedBloc,
      @required AnalyticsRepository analyticsRepository})
      : _journalEntryRepository =
            journalEntryRepository ?? JournalEntryRepository(),
        _analyticsRepository = analyticsRepository,
        _journalFeedBloc = journalFeedBloc;

  final AnalyticsRepository _analyticsRepository;
  final JournalEntryRepository _journalEntryRepository;
  final JournalFeedBloc _journalFeedBloc;

  @override
  EditJournalEntryState get initialState => InitialEdititemState();

  @override
  Stream<EditJournalEntryState> mapEventToState(
    EditJournalEntryEvent event,
  ) async* {
    if (event is SaveJournalEntry) {
      try {
        yield JournalEntryLoading();
        final JournalEntry journalEntry =
            await _journalEntryRepository.saveItem(event.journalEntry);
        _journalFeedBloc.add(FetchFeed());
        _analyticsRepository.logEvent(name: 'journal_entry_edit');
        yield JournalEntrySaved(journalEntry);
      } catch (e) {
        print(e);
        yield JournalEntrySaveError();
      }
    } else if (event is DeleteJournalEntry) {
      try {
        await _journalEntryRepository.deleteItem(event.journalEntry);
        _journalFeedBloc.add(FetchFeed());
        yield JournalEntryDeleted();
      } catch (e) {
        yield JournalEntrySaveError();
      }
    }
  }
}
